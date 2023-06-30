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
    private IValidator<UserBadgeWriteModel> userBadgeWriteModelValidator { get; }
    private IMapper mapper { get; }
    private IBadgeRepository badgeRepository { get; }
    private IUserIdentifierRepository userIdentifierRepository { get; }

    public BadgeController(ILogger logger, IValidator<UserBadgeWriteModel> userBadgeWriteModelValidator, IMapper mapper, IBadgeRepository badgeRepository, IUserIdentifierRepository userIdentifierRepository)
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

    public async Task<BadgeReadModel> GiveBadgeToUser(UserBadgeWriteModel userBadgeWriteModel)
    {
        ValidationResult result = await userBadgeWriteModelValidator.ValidateAsync(userBadgeWriteModel);
        if(!result.IsValid)
        {
            InvalidUserInformationException exception = new(result.Errors
                .Select(error => error.ErrorMessage));
            logger.Error(exception, "Invalid user information");
            throw exception;
        }
        UserIdentifier userIdentifier = 
            await userIdentifierRepository.EnsureInMirror(new() { userIdentifier = userBadgeWriteModel.userId });
        
        logger.Information("Giving badge [{BadgeCode}] to user ID[{UserID}]", userBadgeWriteModel.badgeCode, userIdentifier.userIdentifier);
        BadgeModel recivedBadge = await badgeRepository.GiveBadgeToUser(userIdentifier, userBadgeWriteModel.badgeCode);
        await badgeRepository.Flush();
        
        BadgeReadModel recivedBadgeRead = mapper.Map<BadgeReadModel>(recivedBadge);
        return recivedBadgeRead;
    }

    public async Task<BadgeReadModel> RemoveBadgeFromUser(string userId, BadgeCode badgeCode)
    {
        UserIdentifier userIdentifier = 
            await userIdentifierRepository.EnsureInMirror(new() { userIdentifier = userId });
        
        logger.Information("Removing badge [{BadgeCode}] from user ID[{UserID}]", badgeCode, userIdentifier.userIdentifier);

        BadgeModel removedBadge = await badgeRepository.RemoveBadgeFromUser(userIdentifier, badgeCode);
        await badgeRepository.Flush();
        
        BadgeReadModel removedBadgeRead = mapper.Map<BadgeReadModel>(removedBadge);
        return removedBadgeRead;
    }
}