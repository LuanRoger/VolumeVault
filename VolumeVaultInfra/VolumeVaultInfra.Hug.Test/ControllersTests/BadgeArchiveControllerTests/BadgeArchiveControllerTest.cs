using AutoMapper;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Mapper.Profiles;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Hug.Test.ControllersTests.BadgeArchiveControllerTests.FakeData;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BadgeArchiveControllerTests;

public class BadgeArchiveControllerTest
{
    private BadgeArchiveController badgeArchiveController { get; }
    private Mock<ILogger> logger { get; } = new();
    private Mock<IEmailUserIdentifierRepository> emailUserIdentifierRepository { get; } = new();
    private Mock<IBadgeArchiveRepository> badgeArchiveRepository { get; } = new();
    private Mock<IBadgeRepository> badgeRepository { get; } = new();
    private Mock<IUserIdentifierRepository> userIdentifierRepository { get; } = new();
    private Mock<IAuthRepository> authRepository { get; } = new();

    public BadgeArchiveControllerTest()
    {
        IMapper mapper = new Mapper(new MapperConfiguration(configure =>
        {
            configure.AddProfile<BadgeModelBadgeReadModelMapperProfile>();
        }));
        badgeArchiveController = new(logger.Object, mapper, emailUserIdentifierRepository.Object, badgeArchiveRepository.Object, 
            badgeRepository.Object, userIdentifierRepository.Object, authRepository.Object);
    }
    
    [Fact]
    public async void AttachBadgeToEmailTest()
    {
        EmailUserIdentifier returnedEmailUserIdentifier = BadgeArchiveFakeData.fakeEmailUserIdentifierNoUser;
        BadgeCode badgeToGive = BadgeCode.Tester;
        BadgeModel returnedBadgeModel = BadgeArchiveFakeData.fakeBadgeModel;
        emailUserIdentifierRepository.Setup(ex => 
            ex.EnsureEmailExists(It.IsAny<EmailUserIdentifier>()))
            .ReturnsAsync(returnedEmailUserIdentifier);
        badgeArchiveRepository.Setup(ex => 
            ex.AttachBadgeToEmail(It.IsAny<EmailUserIdentifier>(), badgeToGive))
            .ReturnsAsync(returnedBadgeModel);
        
        BadgeReadModel attachedBadge = await badgeArchiveController
            .AttachBadgeToEmail(returnedEmailUserIdentifier.email, badgeToGive);
        
        Assert.Contains(badgeToGive, attachedBadge.badgeCodes);
        Assert.Equal(1, attachedBadge.count);
    }
    
    [Fact]
    public async void DettachBadgeFromEmailTest()
    {
        EmailUserIdentifier returnedEmailUserIdentifier = BadgeArchiveFakeData.fakeEmailUserIdentifierNoUser;
        BadgeCode badgeToGive = BadgeCode.Tester;
        BadgeModel returnedBadgeModel = BadgeArchiveFakeData.fakeBadgeModel;
        emailUserIdentifierRepository.Setup(ex => 
            ex.EnsureEmailExists(It.IsAny<EmailUserIdentifier>()))
            .ReturnsAsync(returnedEmailUserIdentifier);
        badgeArchiveRepository.Setup(ex => 
            ex.DetachBadgeToEmail(It.IsAny<EmailUserIdentifier>(), badgeToGive))
            .ReturnsAsync(returnedBadgeModel);
        
        BadgeReadModel? detachedBadge = await badgeArchiveController
            .DetachBadgeFromEmail(returnedEmailUserIdentifier.email, badgeToGive);
        
        Assert.NotNull(detachedBadge);
        Assert.Contains(badgeToGive, detachedBadge.badgeCodes);
        Assert.Equal(1, detachedBadge.count);
    }

    [Fact]
    public async void ClaimBadgeFromEmailInArchiveTest()
    {
        const string userEmail = "test@test.com";
        EmailUserIdentifier returnedEmailUserIdentifier = BadgeArchiveFakeData.fakeEmailUserIdentifierNoUser;
        UserIdentifier returnedUserIdentifier = BadgeArchiveFakeData.fakeUserIdentifier;
        UserInfo returnedUserInfo = BadgeArchiveFakeData.fakeUserInfo;
        var returnedBadgeModels = BadgeArchiveFakeData.fakeBadgeModelList;
        emailUserIdentifierRepository.Setup(ex => 
            ex.EnsureEmailExists(It.IsAny<EmailUserIdentifier>()))
            .ReturnsAsync(returnedEmailUserIdentifier);
        authRepository.Setup(ex => ex.GetUserByEmail(It.IsAny<EmailUserIdentifier>()))
            .ReturnsAsync(returnedUserInfo);
        userIdentifierRepository.Setup(ex => ex.EnsureInMirror(It.IsAny<UserIdentifier>()))
            .ReturnsAsync(returnedUserIdentifier);
        badgeArchiveRepository.Setup(ex => ex.DetachBadgesToEmail(It.IsAny<EmailUserIdentifier>()))
            .ReturnsAsync(returnedBadgeModels);

        await badgeArchiveController
            .ClaimBadgeFromEmailInArchive(userEmail);
        
        Assert.NotNull(returnedEmailUserIdentifier.userIdentifier);
    }
}