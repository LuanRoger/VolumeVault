using AutoMapper;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;
using VolumeVaultInfra.Book.Hug.Repositories;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Hug.Controller;

public class BadgeController : IBadgeController
{
    private ILogger logger { get; }
    private IMapper mapper { get; }
    private IBadgeRepository badgeRepository { get; }
    private IUserIdentifierRepository userIdentifierRepository { get; }
    private IEmailUserIdentifierRepository emailUserIdentifierRepository { get; }

    public BadgeController(ILogger logger, IMapper mapper, IBadgeRepository badgeRepository, IUserIdentifierRepository userIdentifierRepository, IEmailUserIdentifierRepository emailUserIdentifierRepository)
    {
        this.logger = logger;
        this.mapper = mapper;
        this.badgeRepository = badgeRepository;
        this.userIdentifierRepository = userIdentifierRepository;
        this.emailUserIdentifierRepository = emailUserIdentifierRepository;
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