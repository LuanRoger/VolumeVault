using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Contexts;

public class DatabaseContext : DbContext
{
    public DbSet<BookModel> books { get; set; } = null!;
    public DbSet<GenreModel> genres { get; set; } = null!;
    public DbSet<BookGenreModel> bookGenre { get; set; } = null!;
    public DbSet<TagModel> tags { get; set; } = null!;
    public DbSet<BookTagModel> bookTag { get; set; } = null!;
    public DbSet<UserIdentifier> userIdentifiers { get; set; } = null!;

    public DatabaseContext(DbContextOptions<DatabaseContext> options)
        : base(options) { }
}