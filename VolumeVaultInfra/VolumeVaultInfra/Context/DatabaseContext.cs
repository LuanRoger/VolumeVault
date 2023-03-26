using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.User;

namespace VolumeVaultInfra.Context;

public class DatabaseContext : DbContext
{
    public DbSet<UserModel> users { get; set; } = null!;
    public DbSet<BookModel> books { get; set; } = null!;
    
    public DatabaseContext(DbContextOptions<DatabaseContext> options)
        : base(options) { }
}