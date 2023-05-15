using VolumeVaultInfra.Book.Services.Hash;

namespace VolumeVaultInfra.Test.ServicesTests;

public class HashAditionalInformationTest
{
    [Fact]
    public void AddInformationTest()
    {
        RelatedInformation relatedInformation = new();
        
        relatedInformation.AddInformation("testInfo");
        
        Assert.True(relatedInformation.hasInformation);
    }
    
    [Fact]
    public void UsesCacheTest()
    {
        RelatedInformation relatedInformation = new();
        
        relatedInformation.AddInformation("testInfo1");
        relatedInformation.AddInformation("testInfo2");
        _ = relatedInformation.ToString();
        
        Assert.True(relatedInformation.cacheHasValue);
    }
    
    [Fact]
    public void GetInformationTest()
    {
        RelatedInformation relatedInformation = new();
        
        relatedInformation.AddInformation("testInfo1");
        relatedInformation.AddInformation("testInfo2");
        
        string result = relatedInformation.ToString();
        Assert.NotEmpty(result);
    }
}