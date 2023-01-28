using FluentValidation;
using FluentValidation.Results;
using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Context;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Services.Hash;
using VolumeVaultInfra.Services.Jwt;

namespace VolumeVaultInfra.Controllers;

public class UserController : IUserController
{
    private DatabaseBaseContext _dbContext { get; }
    private JwtService _jwtService { get; }
    private IValidator<UserWriteModel> _userWriteModelValidator { get; }

    public UserController(DatabaseBaseContext dbContext, JwtService jwtService,
        IValidator<UserWriteModel> userWriteModelValidator)
    {
        _dbContext = dbContext;
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

        UserModel? userVerifier = await _dbContext.users
            .FirstOrDefaultAsync(dbUser => dbUser.username == userWrite.username || dbUser.email == userWrite.email);
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
        
        var userEntry = await _dbContext.users.AddAsync(user);
        await _dbContext.SaveChangesAsync();
        
        return _jwtService.GenerateToken(userEntry.Entity.id);
    }

    public async Task<string> LoginUser(UserLoginRequestModel loginRequest)
    {
        UserModel? userInfo = await _dbContext.users
            .FirstOrDefaultAsync(user => user.username == loginRequest.username);
        
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