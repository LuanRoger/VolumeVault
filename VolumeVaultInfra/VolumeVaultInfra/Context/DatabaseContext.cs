using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Models.Book;

namespace VolumeVaultInfra.Context;

public class DatabaseContext : DbContext
{
    public DbSet<BookModel> books { get; set; } = null!;
    
    public DatabaseContext(DbContextOptions<DatabaseContext> options)
        : base(options) { }
}