using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Context;

public abstract class DatabaseBaseContext : DbContext
{
    public DbSet<UserModel> users { get; set; }
    public DbSet<BookModel> books { get; set; }

    protected DatabaseBaseContext() {}
    protected DatabaseBaseContext(DbContextOptions options) : base(options) { }
 
}