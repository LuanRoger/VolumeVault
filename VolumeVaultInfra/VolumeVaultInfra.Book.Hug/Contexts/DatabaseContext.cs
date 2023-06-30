using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Contexts;

public class DatabaseContext : DbContext
{
    public DbSet<BookModel> books { get; set; } = null!;
    public DbSet<GenreModel> genres { get; set; } = null!;
    public DbSet<BookGenreModel> bookGenre { get; set; } = null!;
    public DbSet<TagModel> tags { get; set; } = null!;
    public DbSet<BookTagModel> bookTag { get; set; } = null!;
    public DbSet<BadgeModel> badges { get; set; } = null!;
    public DbSet<BadgeUserModel> badgeUser { get; set; } = null!;
    public DbSet<BadgeEmailUserModel> badgeEmailClaimQueue { get; set; }
    public DbSet<UserIdentifier> userIdentifiers { get; set; } = null!;
    public DbSet<EmailUserIdentifier> emailUserIdentifiers { get; set; }

    public DatabaseContext(DbContextOptions<DatabaseContext> options)
        : base(options) { }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<BadgeModel>().HasData(new List<BadgeModel>
        {
            new()
            {
                id = 1,
                code = BadgeCode.Creator,
            },
            new()
            {
                id = 2,
                code = BadgeCode.Sponsor,
            },
            new()
            {
                id = 3,
                code = BadgeCode.Tester,
            },
            new()
            {
                id = 4,
                code = BadgeCode.EalryAccessUser,
            },
            new()
            {
                id = 5,
                code = BadgeCode.BugHunter,
            },
            new()
            {
                id = 6,
                code = BadgeCode.OpenSourceContributor,
            }
        });
    }
}