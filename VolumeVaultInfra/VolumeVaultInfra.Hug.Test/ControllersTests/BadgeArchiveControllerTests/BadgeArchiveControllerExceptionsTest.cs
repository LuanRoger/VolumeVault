using AutoMapper;
using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Mapper.Profiles;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Validators;
using VolumeVaultInfra.Hug.Test.ControllersTests.BadgeArchiveControllerTests.FakeData;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BadgeArchiveControllerTests;

public class BadgeArchiveControllerExceptionsTest
{
    private BadgeArchiveController badgeArchiveController { get; }
    private Mock<ILogger> logger { get; } = new();
    private Mock<IEmailUserIdentifierRepository> emailUserIdentifierRepository { get; } = new();
    private Mock<IBadgeArchiveRepository> badgeArchiveRepository { get; } = new();
    private Mock<IBadgeRepository> badgeRepository { get; } = new();
    private Mock<IUserIdentifierRepository> userIdentifierRepository { get; } = new();
    private Mock<IAuthRepository> authRepository { get; } = new();
    
    public BadgeArchiveControllerExceptionsTest()
    {
        IValidator<AttachBadgeToEmailRequest> attachBadgeToEmailRequestValidator = 
            new AttachBadgeToEmailRequestValidator();
        IMapper mapper = new Mapper(new MapperConfiguration(configure =>
        {
            configure.AddProfile<BadgeModelBadgeReadModelMapperProfile>();
        }));
        badgeArchiveController = new(logger.Object, mapper, attachBadgeToEmailRequestValidator, emailUserIdentifierRepository.Object, badgeArchiveRepository.Object, 
            badgeRepository.Object, userIdentifierRepository.Object, authRepository.Object);
    }
    
    [Fact]
    public async void ClaimBadgeFromEmailInArchiveTest()
    {
        ClaimUserBadgesRequest claimUserBadgesRequest = BadgeArchiveFakeData.fakeClaimUserBadgesRequest;
        EmailUserIdentifier returnedEmailUserIdentifier = BadgeArchiveFakeData.fakeEmailUserIdentifierNoUser;
        UserIdentifier returnedUserIdentifier = BadgeArchiveFakeData.fakeUserIdentifier;
        UserInfo? returnedUserInfo = null;
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

        await Assert.ThrowsAsync<UserEmailDoesNotExitsException>(() => badgeArchiveController
            .ClaimBadgeFromEmailInArchive(claimUserBadgesRequest));
    }
}