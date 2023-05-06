using VolumeVaultInfra.Book.Services.Jwt;

namespace VolumeVaultInfra.Test.ServicesTests;

public class JwtServiceTest
{
    [Fact]
    public void TokenGenerationTest()
    {
        const string _jwtTestKey = "ff4a2a7a85505568abd15c6e5bd16fc06e740d4a4675b0a3c5ccc649d5e76299";
        const int userId = 1;
        JwtService jwtService = new(_jwtTestKey);

        string jwt = jwtService.GenerateToken(userId);
        
        Assert.NotEmpty(jwt);
    }
}