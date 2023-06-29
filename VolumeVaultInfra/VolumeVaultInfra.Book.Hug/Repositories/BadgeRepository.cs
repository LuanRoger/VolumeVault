using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public class BadgeRepository : IBadgeRepository
{
    private DatabaseContext badgeDb { get; }

    public BadgeRepository(DatabaseContext badgeDb)
    {
        this.badgeDb = badgeDb;
    }

    public Task<BadgeModel?> GetBadgeByCode(BadgeCodes code) =>
    badgeDb.badges.FirstOrDefaultAsync(badge => badge.code == code);
    
    public async Task<IReadOnlyList<BadgeModel>> GetUserBadges(UserIdentifier user) =>
        await badgeDb.badgeUser
            .Where(badgeUser => badgeUser.userIdentifier == user)
            .Select(badgeUser => badgeUser.badge)
            .ToListAsync();

    public async Task GiveBadgeToUser(UserIdentifier user, BadgeCodes badgeCode)
    {
        BadgeModel badgeModel = await badgeDb.badges.FirstAsync(badge => badge.code == badgeCode);
        await badgeDb.badgeUser.AddAsync(new()
        {
            badge = badgeModel,
            userIdentifier = user
        });
    }

    public async Task RemoveBadgeFromUser(UserIdentifier user, BadgeCodes badgeCode)
    {
        BadgeModel badgeModel = await badgeDb.badges.FirstAsync(badge => badge.code == badgeCode);
        
        await badgeDb.badgeUser.AddAsync(new()
        {
            badge = badgeModel,
            userIdentifier = user
        });
    }

    public async Task Flush() => await badgeDb.SaveChangesAsync();
}