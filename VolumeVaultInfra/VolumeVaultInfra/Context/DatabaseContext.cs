using Microsoft.EntityFrameworkCore;

namespace VolumeVaultInfra.Context;

public class DatabaseContext : DatabaseBaseContext
{
    public DatabaseContext(DbContextOptions options) : base(options) { }
}