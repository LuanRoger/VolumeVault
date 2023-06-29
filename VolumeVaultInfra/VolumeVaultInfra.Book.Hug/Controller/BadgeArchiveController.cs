using AutoMapper;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;
using VolumeVaultInfra.Book.Hug.Repositories;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Hug.Controller;

public class BadgeArchiveController : IBadgeArchiveController
{
    private ILogger logger { get; }
    private IMapper mapper { get; }
    private IEmailUserIdentifierRepository emailUserIdentifierRepository { get; }
    private IUserIdentifierRepository userIdentifierRepository { get; }
    private IBadgeRepository badgeRepository { get; }
    private IBadgeArchiveRepository badgeArchiveRepository { get; }
    private IAuthRepository authRepository { get; }

    public BadgeArchiveController(ILogger logger, IMapper mapper, IEmailUserIdentifierRepository emailUserIdentifierRepository, IBadgeArchiveRepository badgeArchiveRepository, IBadgeRepository badgeRepository, IUserIdentifierRepository userIdentifierRepository, IAuthRepository authRepository)
    {
        this.logger = logger;
        this.mapper = mapper;
        this.emailUserIdentifierRepository = emailUserIdentifierRepository;
        this.userIdentifierRepository = userIdentifierRepository;
        this.badgeRepository = badgeRepository;
        this.badgeArchiveRepository = badgeArchiveRepository;
        this.authRepository = authRepository;
    }
    
    public async Task<BadgeReadModel> AttachBadgeToEmail(string email, BadgeCodes code)
    {
        EmailUserIdentifier emailUserIdentifier = await emailUserIdentifierRepository.EnsureEmailExists(new() { email = email });
        logger.Information("Attaching badge BadgeCode[{BadgeCode}] to email Email[{Email}]", code, emailUserIdentifier.email);
        BadgeModel attachedBadge = await badgeArchiveRepository.AttachBadgeToEmail(emailUserIdentifier, code);
        await badgeArchiveRepository.Flush();
        
        BadgeReadModel badgeReadModel = mapper.Map<BadgeReadModel>(attachedBadge);
        
        return badgeReadModel;
    }
    public async Task<BadgeReadModel?> DetachBadgeToEmail(string email, BadgeCodes code)
    {
        EmailUserIdentifier emailUserIdentifier = await emailUserIdentifierRepository.EnsureEmailExists(new() { email = email});
        logger.Information("Detaching badge BadgeCode[{BadgeCode}] to email Email[{Email}]", code, emailUserIdentifier.email);
        BadgeModel? detachedBadge = await badgeArchiveRepository.DetachBadgeToEmail(emailUserIdentifier, code);
        await badgeArchiveRepository.Flush();
        
        if(detachedBadge is null) return null;
        BadgeReadModel badgeReadModel = mapper.Map<BadgeReadModel>(detachedBadge);
        
        return badgeReadModel;
    }

    public async Task ClaimBadgeFromEmailInArchive(string email)
    {
        EmailUserIdentifier emailUserIdentifier = await emailUserIdentifierRepository.EnsureEmailExists(new() { email = email});
        UserInfo? userInfo = await authRepository.GetUserByEmail(emailUserIdentifier);
        if(userInfo is null)
            throw new UserDoesNotExistsException(email);
        
        UserIdentifier user = await userIdentifierRepository.EnsureInMirror(new() { userIdentifier = userInfo.uid});
        if(emailUserIdentifier.userIdentifier is null)
        {
            logger.Information("The email Email[{UserEmail}] is not related to any User. Relating to Name[{Name}]",
                emailUserIdentifier.email, userInfo.name);
            emailUserIdentifier.userIdentifier = user;
        }
        
        //Remove badges from archive
        var removedBadges = await badgeArchiveRepository.DetachBadgesToEmail(emailUserIdentifier);
        foreach (BadgeModel claimedBadges in removedBadges)
        {
            logger.Information("Removing badge BadgeCode[{BadgeCode}] from archive and claiming to UserIdentifier[{Identifier}]", 
                claimedBadges.code, user.userIdentifier);
            await badgeRepository.GiveBadgeToUser(user, claimedBadges.code);
        }
        
        await badgeRepository.Flush();
    }
}