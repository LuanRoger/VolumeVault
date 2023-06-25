using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;
using VolumeVaultInfra.Book.Hug.Repositories;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Hug.Controller;

public class BadgeController : IBadgeController
{
    private ILogger logger { get; }
    private IBadgeRepository badgeRepository { get; }
    private IUserIdentifierRepository userIdentifierRepository { get; }

    public BadgeController(ILogger logger, IBadgeRepository badgeRepository, IUserIdentifierRepository userIdentifierRepository)
    {
        this.logger = logger;
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

    public async Task GiveBadgeToUser(string userId, BadgeCodes badgeCode)
    {
        UserIdentifier userIdentifier = 
            await userIdentifierRepository.EnsureInMirror(new() { userIdentifier = userId });
        
        logger.Information("Giving badge [{BadgeCode}] to user ID[{UserID}]", badgeCode, userIdentifier.userIdentifier);
        await badgeRepository.GiveBadgeToUser(userIdentifier, badgeCode);
        await badgeRepository.Flush();
    }

    public async Task RemoveBadgeFromUser(string userId, BadgeCodes badgeCode)
    {
        UserIdentifier userIdentifier = 
            await userIdentifierRepository.EnsureInMirror(new() { userIdentifier = userId });
        
        logger.Information("Removing badge [{BadgeCode}] from user ID[{UserID}]", badgeCode, userIdentifier.userIdentifier);
        await badgeRepository.RemoveBadgeFromUser(userIdentifier, badgeCode);
        await badgeRepository.Flush();
    }
}