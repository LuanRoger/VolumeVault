using FluentValidation;
using FluentValidation.Results;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Services.Hash;
using VolumeVaultInfra.Services.Jwt;

namespace VolumeVaultInfra.Controllers;

public class UserController : IUserController
{
    private IUserRepository _userRepository { get; }
    private JwtService _jwtService { get; }
    private IValidator<UserWriteModel> _userWriteModelValidator { get; }

    public UserController(IUserRepository userRepository, JwtService jwtService,
        IValidator<UserWriteModel> userWriteModelValidator)
    {
        _userRepository = userRepository;
        _jwtService = jwtService;
        _userWriteModelValidator = userWriteModelValidator;
    }
    
    public async Task<string> SigninUser(UserWriteModel userWrite)
    {
        ValidationResult validationResult = await _userWriteModelValidator.ValidateAsync(userWrite);
        if(!validationResult.IsValid)
            throw new NotValidUserWriteException(validationResult
                .Errors
                .Select(errors => errors.ErrorMessage)
                .ToList());

        UserModel? userVerifier = await _userRepository
            .SearchUserByUsernameOrEmail(userWrite.username, userWrite.email);
        if(userVerifier is not null)
            throw new UserAlreadyExistException();

        RelatedInformation userInformationToHash = new();
        userInformationToHash.AddInformation(userWrite.username);
        UserModel user = new()
        {
            username = userWrite.username,
            email = userWrite.email,
            password = await HashService.HashPassword(userWrite.password, userInformationToHash)
        };
        
        UserModel userEntry = await _userRepository.AddUser(user);
        await _userRepository.Flush();
        
        return _jwtService.GenerateToken(userEntry.id);
    }

    public async Task<string> LoginUser(UserLoginRequestModel loginRequest)
    {
        UserModel? userInfo = await _userRepository.GetUserByUsername(loginRequest.username);
        if(userInfo is null)
            throw new UsernameIsNotRegisteredException(loginRequest.username);
        
        RelatedInformation userRelatedInformation = new();
        userRelatedInformation.AddInformation(loginRequest.username);
        string hashedPassword = await HashService
            .HashPassword(loginRequest.password, userRelatedInformation);
        if(userInfo.password != hashedPassword)
            throw new InvalidUserCredentialsException(userInfo.username);
        
        return _jwtService.GenerateToken(userInfo.id);
    }
}