using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Models;
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

    public Task<BadgeModel?> GetBadgeByCode(BadgeCode code) =>
    badgeDb.badges.FirstOrDefaultAsync(badge => badge.code == code);
    
    public async Task<IReadOnlyList<BadgeModel>> GetUserBadges(UserIdentifier user) =>
        await badgeDb.badgeUser
            .Where(badgeUser => badgeUser.userIdentifier == user)
            .Select(badgeUser => badgeUser.badge)
            .ToListAsync();

    public async Task<BadgeModel?> GiveBadgeToUser(UserIdentifier user, BadgeGivingUser badgeGivingUserInfo)
    {
        BadgeUserModel? allreadyClaimedBadge = await badgeDb.badgeUser
            .FirstOrDefaultAsync(badgeUser => badgeUser.userIdentifier == user && 
            badgeUser.badge.code == badgeGivingUserInfo.badgeCode);
        if(allreadyClaimedBadge is not null)
            return null;
            
        BadgeModel badgeModel = await badgeDb.badges.FirstAsync(badge => badge.code == badgeGivingUserInfo.badgeCode);
        await badgeDb.badgeUser.AddAsync(new()
        {
            badge = badgeModel,
            userIdentifier = user,
            claimedAt = badgeGivingUserInfo.recivedAt
        });
        
        return badgeModel;
    }

    public async Task<BadgeModel?> RemoveBadgeFromUser(UserIdentifier user, BadgeCode badgeCode)
    {
        BadgeModel badgeModel = await badgeDb.badges.FirstAsync(badge => badge.code == badgeCode);
        BadgeUserModel? badgeUserModel = await badgeDb.badgeUser
            .FirstOrDefaultAsync(badgeUser => badgeUser.userIdentifier == user && 
                                              badgeUser.badge == badgeModel);
        if(badgeUserModel is null)
            return null;
        badgeDb.badgeUser.Remove(badgeUserModel);
        
        return badgeUserModel.badge;
    }

    public async Task Flush() => await badgeDb.SaveChangesAsync();
}