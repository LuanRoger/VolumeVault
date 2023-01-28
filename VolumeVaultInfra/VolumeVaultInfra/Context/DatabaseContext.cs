using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Context;

public class DatabaseContext : DatabaseBaseContext
{
    public DbSet<UserModel> users { get; set; }
    public DbSet<BookModel> books { get; set; }

    public DatabaseContext(DbContextOptions options) : base(options) { }
}