using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Context;

public abstract class DatabaseBaseContext : DbContext
{
    public DbSet<UserModel> users { get; }
    public DbSet<BookModel> books { get; }

    protected DatabaseBaseContext(DbContextOptions options) : base(options) { }
}