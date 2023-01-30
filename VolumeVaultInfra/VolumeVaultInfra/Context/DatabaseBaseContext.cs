using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Context;

public abstract class DatabaseBaseContext : DbContext
{
    public DbSet<UserModel> users => null!;
    public DbSet<BookModel> books => null!;

    protected DatabaseBaseContext() {}
    protected DatabaseBaseContext(DbContextOptions options) : base(options) { }
 
}