using AutoMapper;
using FluentValidation;
using Moq;
using Serilog;
using VolumeVaultInfra.Book.Hug.Controller;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Mapper.Profiles;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Validators;
using VolumeVaultInfra.Hug.Test.ControllersTests.BadgeControllerTests.FakeData;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BadgeControllerTests;

public class BadgeControllerExceptionTest
{
    private Mock<ILogger> logger { get; } = new();
    private Mock<IBadgeRepository> badgeRepository { get; } = new();
    private Mock<IUserIdentifierRepository> userIdentifierRepository { get; } = new();
    private BadgeController badgeController { get; }

    public BadgeControllerExceptionTest()
    {
        IValidator<GiveUserBadgeRequest> userBadgeWriteModelValidator = new UserBadgeWriteModelValidator();
        IMapper badgeReadModelMapper = new Mapper(new MapperConfiguration(configure =>
        {
            configure.AddProfile<BadgeModelBadgeReadModelMapperProfile>();
        }));
        badgeController = new(logger.Object, userBadgeWriteModelValidator, badgeReadModelMapper, badgeRepository.Object, userIdentifierRepository.Object);
    }
    
    [Fact]
    public async void GiveBadgeToUserInvalidUserInformationExceptionTest()
    {
        GiveUserBadgeRequest giveUserBadgeRequest = BadgeFakeData.fakeInvalidGiveUserBadgeRequest;
        
        await Assert.ThrowsAsync<InvalidUserInformationException>(() => 
            badgeController.GiveBadgeToUser(giveUserBadgeRequest));
    }
}