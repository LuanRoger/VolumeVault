using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Repositories;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Hug.Controller;

public class AuthController : IAuthController
{
    private ILogger logger { get; }
    private IAuthRepository authRepository { get; }
    private IUserIdentifierRepository userIdentifierRepository { get; }
    private IEmailUserIdentifierRepository emailUserIdentifierRepository { get; }

    public AuthController(ILogger logger, IAuthRepository authRepository, IUserIdentifierRepository userIdentifierRepository, IEmailUserIdentifierRepository emailUserIdentifierRepository)
    {
        this.logger = logger;
        this.authRepository = authRepository;
        this.userIdentifierRepository = userIdentifierRepository;
        this.emailUserIdentifierRepository = emailUserIdentifierRepository;
    }

    public async Task<UserInfo> GetUserFromAuthWEmail(string email)
    {
        EmailUserIdentifier emailUserIdentifier = await emailUserIdentifierRepository.EnsureEmailExists(new() { email = email });
        logger.Information("Getting user from Auth with Email[{Email}]", email);
        
        UserInfo? user = await authRepository.GetUserByEmail(emailUserIdentifier);
        if(user is null)
        {
            UserEmailDoesNotExitsException exception = new(email);
            logger.Error(exception, "The user with Email[{Email}] does not exists", email);
            throw exception;
        }
        
        return user;
    }

    public async Task<UserInfo> GetUserFromAuthWIdentifier(string userId)
    {
        UserIdentifier userIdentifier = await userIdentifierRepository.EnsureInMirror(new() { userIdentifier = userId});
        logger.Information("Getting user from Auth with Identifier[{Identifier}]", userId);
        
        UserInfo? user = await authRepository.GetUser(userIdentifier);
        if(user is null)
        {
            UserDoesNotExistsException exception = new(userId);
            logger.Error(exception, "The user with Identifier[{Identifier}] does not exists", userId);
            throw exception;
        }
        
        return user;
    }
}