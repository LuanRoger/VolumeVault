using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Models.Book;

namespace VolumeVaultInfra.Book.Context;

public class DatabaseContext : DbContext
{
    public DbSet<BookModel> books { get; set; } = null!;
    
    public DatabaseContext(DbContextOptions<DatabaseContext> options)
        : base(options) { }
}