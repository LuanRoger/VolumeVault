using AutoMapper;
using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Mapper.Profiles;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Validators;
using VolumeVaultInfra.Hug.Test.ControllersTests.BadgeControllerTests.FakeData;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BadgeControllerTests;

public class BadgeControllerTest
{
    private Mock<ILogger> logger { get; } = new();
    private Mock<IBadgeRepository> badgeRepository { get; } = new();
    private Mock<IUserIdentifierRepository> userIdentifierRepository { get; } = new();
    private BadgeController badgeController { get; }

    public BadgeControllerTest()
    {
        IValidator<UserBadgeWriteModel> userBadgeWriteModelValidator = new UserBadgeWriteModelValidator();
        IMapper badgeReadModelMapper = new Mapper(new MapperConfiguration(configure =>
        {
            configure.AddProfile<BadgeModelBadgeReadModelMapperProfile>();
        }));
        badgeController = new(logger.Object, userBadgeWriteModelValidator, badgeReadModelMapper, badgeRepository.Object, userIdentifierRepository.Object);
    }
    
    private List<BadgeModel> fakeBadgeModels => new()
    {
        new()
        {
            id = 1,
            code = BadgeCode.Tester,
        },
        new()
        {
            id = 2,
            code = BadgeCode.BugHunter,
        },
        new()
        {
            id = 3,
            code = BadgeCode.OpenSourceContributor,
        },
    };
    
    [Fact]
    public async void GetUserBadgeTest()
    {
        const string userId = "0";
        UserIdentifier userIdentifier = BadgeFakeData.fakeUserIdentifier;
        userIdentifierRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(userIdentifier);
        badgeRepository.Setup(ex => ex.GetUserBadges(userIdentifier))
            .ReturnsAsync(fakeBadgeModels);
        
        BadgeReadModel badgeReadModel = await badgeController.GetUserBadges(userId);
        
        Assert.Equal(fakeBadgeModels.Count, badgeReadModel.count);
        Assert.Contains(fakeBadgeModels[0].code, badgeReadModel.badgeCodes);
        Assert.Contains(fakeBadgeModels[1].code, badgeReadModel.badgeCodes);
        Assert.Contains(fakeBadgeModels[2].code, badgeReadModel.badgeCodes);
    }
    
    [Fact]
    public async void GiveBadgeToUserTest()
    {
        UserBadgeWriteModel badgeWriteModel = BadgeFakeData.fakeUserBadgeWriteModel;
        const BadgeCode badgeToGive = BadgeCode.Tester;
        UserIdentifier userIdentifier = BadgeFakeData.fakeUserIdentifier;
        userIdentifierRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(userIdentifier);
        badgeRepository.Setup(ex => ex.GiveBadgeToUser(It.IsAny<UserIdentifier>(), badgeToGive))
            .ReturnsAsync(BadgeFakeData.fakeBadgeModel);
        
        BadgeReadModel recivedBadge = await badgeController.GiveBadgeToUser(badgeWriteModel);
        
        Assert.Equal(1, recivedBadge.count);
        Assert.Equal(badgeToGive, recivedBadge.badgeCodes[0]);
    }
    
    [Fact]
    public async void RemoveBadgeFromUserTest()
    {
        const string userId = "0";
        const BadgeCode badgeToRemove = BadgeCode.Tester;
        UserIdentifier userIdentifier = BadgeFakeData.fakeUserIdentifier;
        userIdentifierRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(userIdentifier);
        badgeRepository.Setup(ex => ex.RemoveBadgeFromUser(It.IsAny<UserIdentifier>(), badgeToRemove))
            .ReturnsAsync(BadgeFakeData.fakeBadgeModel);
        
        BadgeReadModel removedBadge = await badgeController.RemoveBadgeFromUser(userId, badgeToRemove);
        
        Assert.Equal(1, removedBadge.count);
        Assert.Equal(badgeToRemove, removedBadge.badgeCodes[0]);
    }
}