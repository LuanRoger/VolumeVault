using System.Text;
using Konscious.Security.Cryptography;

namespace VolumeVaultInfra.Services.Hash;

public class HashService
{
    public static async Task<string> HashPassword(string password, RelatedInformation? relatedInformation = null)
    {
        Argon2 argon = new Argon2i(Encoding.UTF8.GetBytes(password));
        argon.DegreeOfParallelism = 4;
        argon.MemorySize = 8192;
        argon.Iterations = 20;
        if(relatedInformation is not null)
            argon.AssociatedData = Encoding.UTF8.GetBytes(relatedInformation!.ToString());
        
        byte[] hashPassword = await argon.GetBytesAsync(64);
        return Convert.ToBase64String(hashPassword);
    }
}