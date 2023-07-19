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

public class BadgeController : IBadgeController
{
    private ILogger logger { get; }
    private IValidator<GiveUserBadgeRequest> userBadgeWriteModelValidator { get; }
    private IMapper mapper { get; }
    private IBadgeRepository badgeRepository { get; }
    private IUserIdentifierRepository userIdentifierRepository { get; }

    public BadgeController(ILogger logger, IValidator<GiveUserBadgeRequest> userBadgeWriteModelValidator, IMapper mapper, IBadgeRepository badgeRepository, IUserIdentifierRepository userIdentifierRepository)
    {
        this.logger = logger;
        this.userBadgeWriteModelValidator = userBadgeWriteModelValidator;
        this.mapper = mapper;
        this.badgeRepository = badgeRepository;
        this.userIdentifierRepository = userIdentifierRepository;
    }

    public async Task<BadgeReadModel> GetUserBadges(string userId)
    {
        UserIdentifier userIdentifier = 
        await userIdentifierRepository.EnsureInMirror(new() { userIdentifier = userId });
        
        logger.Information("Getting badges from user ID[{UserID}]", userIdentifier.userIdentifier);
        var userBadges = await badgeRepository.GetUserBadges(userIdentifier);
        BadgeReadModel userBadgeRead = new()
        {
            count = userBadges.Count,
            badgeCodes = userBadges.Select(badge => badge.code).ToList()
        };
        logger.Information("Found [{BadgeCount}] badges for user ID[{UserID}]", userBadgeRead.count, userIdentifier.userIdentifier);
        
        return userBadgeRead;
    }

    public async Task<BadgeReadModel> GiveBadgeToUser(GiveUserBadgeRequest giveUserBadgeRequest)
    {
        ValidationResult result = await userBadgeWriteModelValidator.ValidateAsync(giveUserBadgeRequest);
        if(!result.IsValid)
        {
            InvalidUserInformationException exception = new(result.Errors
                .Select(error => error.ErrorMessage));
            logger.Error(exception, "Invalid user information");
            throw exception;
        }
        UserIdentifier userIdentifier = 
            await userIdentifierRepository.EnsureInMirror(new() { userIdentifier = giveUserBadgeRequest.userId });
        
        logger.Information("Giving badge [{BadgeCode}] to user ID[{UserID}]", giveUserBadgeRequest.badgeCode, userIdentifier.userIdentifier);
        BadgeGivingUser badgeGivingUser = new()
        {
            badgeCode = giveUserBadgeRequest.badgeCode,
            recivedAt = giveUserBadgeRequest.recivedAt
        };
        BadgeModel? recivedBadge = await badgeRepository.GiveBadgeToUser(userIdentifier, badgeGivingUser);
        if(recivedBadge is null)
        {
            AllreadyClaimedBadgeException exception = new(giveUserBadgeRequest.badgeCode, userIdentifier.userIdentifier);
            logger.Error(exception, "User ID[{UserID}] allready has badge [{BadgeCode}]",
                userIdentifier.userIdentifier, giveUserBadgeRequest.badgeCode);
            throw exception;
        }
        
        await badgeRepository.Flush();
        
        BadgeReadModel recivedBadgeRead = mapper.Map<BadgeReadModel>(recivedBadge);
        return recivedBadgeRead;
    }

    public async Task<BadgeReadModel?> RemoveBadgeFromUser(string userId, BadgeCode badgeCode)
    {
        UserIdentifier userIdentifier = 
            await userIdentifierRepository.EnsureInMirror(new() { userIdentifier = userId });
        
        logger.Information("Removing badge [{BadgeCode}] from user ID[{UserID}]", badgeCode, userIdentifier.userIdentifier);

        BadgeModel? removedBadge = await badgeRepository.RemoveBadgeFromUser(userIdentifier, badgeCode);
        await badgeRepository.Flush();
        
        BadgeReadModel? removedBadgeRead = removedBadge is not null ? 
            mapper.Map<BadgeReadModel>(removedBadge) : null;
        return removedBadgeRead;
    }
}