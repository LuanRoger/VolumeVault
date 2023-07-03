using AutoMapper;
using FluentValidation;
using FluentValidation.Results;
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
    private IValidator<AttachBadgeToEmailRequest> attachBadgeToEmailRequestValidator { get; }
    private IEmailUserIdentifierRepository emailUserIdentifierRepository { get; }
    private IUserIdentifierRepository userIdentifierRepository { get; }
    private IBadgeRepository badgeRepository { get; }
    private IBadgeArchiveRepository badgeArchiveRepository { get; }
    private IAuthRepository authRepository { get; }

    public BadgeArchiveController(ILogger logger, IMapper mapper, IValidator<AttachBadgeToEmailRequest> attachBadgeToEmailRequestValidator, IEmailUserIdentifierRepository emailUserIdentifierRepository, IBadgeArchiveRepository badgeArchiveRepository, IBadgeRepository badgeRepository, IUserIdentifierRepository userIdentifierRepository, IAuthRepository authRepository)
    {
        this.logger = logger;
        this.mapper = mapper;
        this.attachBadgeToEmailRequestValidator = attachBadgeToEmailRequestValidator;
        this.emailUserIdentifierRepository = emailUserIdentifierRepository;
        this.userIdentifierRepository = userIdentifierRepository;
        this.badgeRepository = badgeRepository;
        this.badgeArchiveRepository = badgeArchiveRepository;
        this.authRepository = authRepository;
    }
    
    public async Task<BadgeReadModel> AttachBadgeToEmail(AttachBadgeToEmailRequest requestInfo)
    {
        ValidationResult result = await attachBadgeToEmailRequestValidator.ValidateAsync(requestInfo);
        if(!result.IsValid)
        {
            InvalidAttachBadgeInformationException exception = new(result.Errors
                .Select(errors => errors.ErrorMessage));
            logger.Error(exception, "he attachment badge information is not valid");
            throw exception;
        }
        
        EmailUserIdentifier emailUserIdentifier = await emailUserIdentifierRepository.EnsureEmailExists(new() { email = requestInfo.email });
        logger.Information("Attaching badge BadgeCode[{BadgeCode}] to email Email[{Email}]", requestInfo.badgeCode, emailUserIdentifier.email);
        AttachBadgeToEmailInfo attachBadgeToEmailInfo = new()
        {
            badgeCode = requestInfo.badgeCode,
            attachDate = requestInfo.attachDate
        };
        BadgeModel attachedBadge = await badgeArchiveRepository.AttachBadgeToEmail(emailUserIdentifier, attachBadgeToEmailInfo);
        await badgeArchiveRepository.Flush();
        
        BadgeReadModel badgeReadModel = mapper.Map<BadgeReadModel>(attachedBadge);
        
        return badgeReadModel;
    }
    public async Task<BadgeReadModel?> DetachBadgeFromEmail(string email, BadgeCode code)
    {
        EmailUserIdentifier emailUserIdentifier = await emailUserIdentifierRepository.EnsureEmailExists(new() { email = email});
        logger.Information("Detaching badge BadgeCode[{BadgeCode}] to email Email[{Email}]", code, 
            emailUserIdentifier.email);
        BadgeModel? detachedBadge = await badgeArchiveRepository.DetachBadgeToEmail(emailUserIdentifier, code);
        await badgeArchiveRepository.Flush();
        
        if(detachedBadge is null) return null;
        BadgeReadModel badgeReadModel = mapper.Map<BadgeReadModel>(detachedBadge);
        
        return badgeReadModel;
    }

    public async Task<BadgeReadModel> GetUserBadgesOnArchive(string email)
    {
        EmailUserIdentifier emailUserIdentifier = await emailUserIdentifierRepository
            .EnsureEmailExists(new() { email = email});
        logger.Information("Retrieving badges from archive to Email[{Email}]", emailUserIdentifier.email);
        var userBadgesOnArchive = await badgeArchiveRepository
            .GetUserBadgesOnArchive(emailUserIdentifier);
        
        BadgeReadModel userBadgesReadModel = new()
        {
            count = userBadgesOnArchive.Count,
            badgeCodes = userBadgesOnArchive
                .Select(badges => badges.code).ToList()
        };
        return userBadgesReadModel;
    }

    public async Task<BadgeReadModel> ClaimBadgeFromEmailInArchive(ClaimUserBadgesRequest requestInfo)
    {
        EmailUserIdentifier emailUserIdentifier = await emailUserIdentifierRepository.EnsureEmailExists(new() { email = requestInfo.email});
        UserInfo? userInfo = await authRepository.GetUserByEmail(emailUserIdentifier);
        if(userInfo is null)
            throw new UserEmailDoesNotExitsException(requestInfo.email);
        
        UserIdentifier user = await userIdentifierRepository.EnsureInMirror(new() { userIdentifier = userInfo.uid});
        if(emailUserIdentifier.userIdentifier is null)
        {
            logger.Information("The email Email[{UserEmail}] is not related to any user. Relating to Name[{Name}]",
                emailUserIdentifier.email, userInfo.displayName);
            emailUserIdentifier.userIdentifier = user;
        }
        
        //Remove badges from archive
        var removedBadges = await badgeArchiveRepository.DetachBadgesToEmail(emailUserIdentifier);
        foreach (BadgeModel claimedBadge in removedBadges)
        {
            logger.Information("Removing badge BadgeCode[{BadgeCode}] from archive and claiming to UserIdentifier[{Identifier}]", 
                claimedBadge.code, user.userIdentifier);
            BadgeGivingUser badgeGivingUserInfo = new()
            {
                badgeCode = claimedBadge.code,
                recivedAt = requestInfo.claimedAt
            };
            await badgeRepository.GiveBadgeToUser(user, badgeGivingUserInfo);
        }

        await badgeRepository.Flush();
        
        BadgeReadModel claimedBadges = new()
        {
            count = removedBadges.Count,
            badgeCodes = removedBadges
                .Select(badges => badges.code).ToList()
        };
        return claimedBadges;
    }
}