using FluentValidation;
using FluentValidation.Results;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Services.Hash;
using VolumeVaultInfra.Services.Jwt;
using VolumeVaultInfra.Services.Metrics;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Controllers;

public class UserController : IUserController
{
    private IUserRepository _userRepository { get; }
    private JwtService _jwtService { get; }
    private IUserControllerMetrics _metrics { get; }
    private IValidator<UserWriteModel> _userWriteModelValidator { get; }
    private ILogger _logger { get; }

    public UserController(IUserRepository userRepository, JwtService jwtService, 
        IUserControllerMetrics metrics, IValidator<UserWriteModel> userWriteModelValidator,
        ILogger logger)
    {
        _userRepository = userRepository;
        _jwtService = jwtService;
        _metrics = metrics;
        _userWriteModelValidator = userWriteModelValidator;
        _logger = logger;
    }
    
    public async Task<string> SigninUser(UserWriteModel userWrite)
    {
        ValidationResult validationResult = await _userWriteModelValidator.ValidateAsync(userWrite);
        if(!validationResult.IsValid)
        {
            Exception ex = new NotValidUserWriteException(validationResult
                .Errors
                .Select(errors => errors.ErrorMessage)
                .ToList());
            _logger.Error(ex, ex.Message);
            throw ex;
        }

        UserModel? userVerifier = await _userRepository
            .SearchUserByUsernameOrEmail(userWrite.username, userWrite.email);
        if(userVerifier is not null)
        {
            Exception ex = new UserAlreadyExistException();
            _logger.Error(ex, ex.Message);
            throw ex;   
        }
        _logger.Information("Siging new user: Username[{0}].", userWrite.username);

        RelatedInformation userInformationToHash = new();
        userInformationToHash.AddInformation(userWrite.username);
        _logger.Information("Adding information to hash with password.");

        UserModel user = new()
        {
            username = userWrite.username,
            email = userWrite.email,
            password = await HashService.HashPassword(userWrite.password, userInformationToHash)
        };

        UserModel userEntry = await _userRepository.AddUser(user);
        await _userRepository.Flush();
        _metrics.IncreaseRegisteredUsers();
        _logger.Information("User registered sucessfully: ID[{0}]", userEntry.id);
        
        _logger.Information("Generating JWT for new user.");
        return _jwtService.GenerateToken(userEntry.id);
    }

    public async Task<string> LoginUser(UserLoginRequestModel loginRequest)
    {
        UserModel? userInfo = await _userRepository.GetUserByUsername(loginRequest.username);
        if(userInfo is null)
        {
            Exception ex = new UsernameIsNotRegisteredException(loginRequest.username);
            _logger.Error(ex, ex.Message);
            throw ex;
        }
        _logger.Information("Loging Username[{0}]...", userInfo.username);

        RelatedInformation userRelatedInformation = new();
        userRelatedInformation.AddInformation(loginRequest.username);
        string hashedPassword = await HashService
            .HashPassword(loginRequest.password, userRelatedInformation);
        if(userInfo.password != hashedPassword)
        {
            Exception ex = new InvalidUserCredentialsException(userInfo.username);
            _logger.Error(ex, ex.Message);
            throw ex;
        }
        
        _logger.Information("Generating JWT for new user.");
        _metrics.IncreaseNumberLogins();
        return _jwtService.GenerateToken(userInfo.id);
    }
}