using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Contexts;
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

    public async Task<BadgeModel> AttachBadgeToEmail(EmailUserIdentifier emailUserIdentifier, BadgeCode code)
    {
        BadgeEmailUserModel? attatchedBadge = context.badgeEmailClaimQueue.FirstOrDefault(claim => claim.emailUserIdentifier == emailUserIdentifier && claim.badge.code == code);
        if(attatchedBadge is not null)
        {
            await context.Entry(attatchedBadge)
                .Reference(entity => entity.badge)
                .LoadAsync();
            return attatchedBadge.badge;
        }
        
        BadgeModel badgeModel = await context.badges.FirstAsync(badge => badge.code == code);
        await context.badgeEmailClaimQueue.AddAsync(new()
        {
            badge = badgeModel,
            emailUserIdentifier = emailUserIdentifier
        });
        
        return badgeModel;
    }
    
    public async Task<BadgeModel?> DetachBadgeToEmail(EmailUserIdentifier emailUserIdentifier, BadgeCode code)
    {
        BadgeEmailUserModel? badgeToRemove = await context.badgeEmailClaimQueue.FirstOrDefaultAsync(claim => 
            claim.emailUserIdentifier == emailUserIdentifier && claim.badge.code == code);
        if(badgeToRemove is null) return null;
        
        await context.Entry(badgeToRemove)
            .Reference(entity => entity.badge)
            .LoadAsync();
        BadgeModel removedBadge = badgeToRemove.badge;
        context.badgeEmailClaimQueue.Remove(badgeToRemove);

        return removedBadge;
    }
    public async Task<IReadOnlyList<BadgeModel>> DetachBadgesToEmail(EmailUserIdentifier emailUserIdentifier)
    {
        var badgeEmail = await context.badgeEmailClaimQueue
            .Where(badgeEmail => badgeEmail.emailUserIdentifier == emailUserIdentifier)
            .ToListAsync();
        
        List<BadgeModel> removedBadges = new();
        foreach (BadgeEmailUserModel badgeEmailUser in badgeEmail)
            removedBadges.Add((context.badgeEmailClaimQueue.Remove(badgeEmailUser)).Entity.badge);
        
        return removedBadges;
    }
    
    public async Task Flush() => await context.SaveChangesAsync();
}