using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public class BadgeArchiveRepository : IBadgeArchiveRepository
{
    private DatabaseContext context { get; }

    public BadgeArchiveRepository(DatabaseContext context)
    {
        this.context = context;
    }
    
    public async Task<IReadOnlyList<BadgeModel>> GetUserBadgesOnArchive(EmailUserIdentifier emailUserIdentifier) =>
        await context.badgeEmailArchive.AsNoTracking()
            .Where(badgeEmail => badgeEmail.emailUserIdentifier == emailUserIdentifier)
            .Select(badgeEmail => badgeEmail.badge)
            .ToListAsync();
    
    public async Task<BadgeModel> AttachBadgeToEmail(EmailUserIdentifier emailUserIdentifier, AttachBadgeToEmailInfo attachInfo)
    {
        BadgeEmailUserModel? attatchedBadge = context.badgeEmailArchive.AsNoTracking()
            .FirstOrDefault(claim => 
                claim.emailUserIdentifier == emailUserIdentifier && claim.badge.code == attachInfo.badgeCode);
        if(attatchedBadge is not null)
        {
            await context.Entry(attatchedBadge)
                .Reference(entity => entity.badge)
                .LoadAsync();
            return attatchedBadge.badge;
        }
        
        BadgeModel badgeModel = await context.badges
            .FirstAsync(badge => badge.code == attachInfo.badgeCode);
        await context.badgeEmailArchive.AddAsync(new()
        {
            badge = badgeModel,
            emailUserIdentifier = emailUserIdentifier,
            attachDateTime = attachInfo.attachDate
        });
        
        return badgeModel;
    }
    
    public async Task<BadgeModel?> DetachBadgeToEmail(EmailUserIdentifier emailUserIdentifier, BadgeCode code)
    {
        BadgeEmailUserModel? badgeToRemove = await context.badgeEmailArchive
            .FirstOrDefaultAsync(claim => 
            claim.emailUserIdentifier == emailUserIdentifier && claim.badge.code == code);
        if(badgeToRemove is null) return null;
        
        await context.Entry(badgeToRemove)
            .Reference(entity => entity.badge)
            .LoadAsync();
        BadgeModel removedBadge = badgeToRemove.badge;
        context.badgeEmailArchive.Remove(badgeToRemove);

        return removedBadge;
    }
    public async Task<IReadOnlyList<BadgeModel>> DetachBadgesToEmail(EmailUserIdentifier emailUserIdentifier)
    {
        var badgeEmail = await context.badgeEmailArchive
            .Where(badgeEmail => badgeEmail.emailUserIdentifier == emailUserIdentifier)
            .ToListAsync();
        
        List<BadgeModel> removedBadges = new();
        foreach (BadgeEmailUserModel badgeEmailUser in badgeEmail)
        { 
            await context.Entry(badgeEmailUser)
                .Reference(entity => entity.badge)
                .LoadAsync();
            removedBadges.Add(badgeEmailUser.badge);
            context.badgeEmailArchive.Remove(badgeEmailUser);
        }

        return removedBadges;
    }

    public async Task Flush() => await context.SaveChangesAsync();
}