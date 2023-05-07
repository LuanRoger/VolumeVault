using VolumeVaultInfra.Book.Services.Hash;

namespace VolumeVaultInfra.Test.ServicesTests;

public class HashServiceTest
{
    [Fact]
    public async void HashValueTest()
    {
        string fakePassword = "password123";
        
        string hashedPassword = await HashService.HashPassword(fakePassword);
        
        Assert.NotEmpty(hashedPassword);
    }
    
    [Fact]
    public async void HashValueWithRelatedInformationsTest()
    {
        string fakePassword = "password123";
        RelatedInformation relatedInformation = new();
        relatedInformation.AddInformation("info1");
        relatedInformation.AddInformation("info2");
        relatedInformation.AddInformation("info3");
        
        string hashedPassword = await HashService.HashPassword(fakePassword, relatedInformation);
        
        Assert.NotEmpty(hashedPassword);
    }
}