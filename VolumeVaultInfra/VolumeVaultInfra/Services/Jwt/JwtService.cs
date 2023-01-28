using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;

namespace VolumeVaultInfra.Services.Jwt;

public class JwtService
{
    private byte[] _simetricKey { get; }

    public JwtService(string simetricKey)
    {
        _simetricKey = Encoding.UTF8.GetBytes(simetricKey);
    }
    
    public string GenerateToken(int userId)
    {
        JsonWebTokenHandler handler = new();
        string jwt = handler.CreateToken(new SecurityTokenDescriptor
        {
            Subject = new(new []
            {
                new Claim("ID", userId.ToString())
            }),
            SigningCredentials = new(new SymmetricSecurityKey(_simetricKey), 
                SecurityAlgorithms.HmacSha256Signature),
            Issuer = JwtServiceConsts.jwtIssuer,
            IssuedAt = DateTime.Now,
            Expires = DateTime.Now.AddDays(7),
            Audience = JwtServiceConsts.jwtAudience
        });
        
        return jwt;
    }
}