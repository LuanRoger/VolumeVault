using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public class EmailUserIdentifierRepository : IEmailUserIdentifierRepository
{
    private DatabaseContext context { get; }

    public EmailUserIdentifierRepository(DatabaseContext context)
    {
        this.context = context;
    }
    
    public async Task<EmailUserIdentifier> EnsureEmailExists(EmailUserIdentifier emailUserIdentifier)
    {
        EmailUserIdentifier? identifier = await context.emailUserIdentifiers.FirstOrDefaultAsync(emailIdentifier => emailIdentifier.email == emailUserIdentifier.email);
        identifier ??= (await context.emailUserIdentifiers.AddAsync(emailUserIdentifier)).Entity;
        
        return identifier;
    }

    public async Task RelateToUser(string email, UserIdentifier userIdentifier)
    {
        EmailUserIdentifier? toRelate = await context.emailUserIdentifiers.FirstOrDefaultAsync(emailUser => emailUser.email == email);
        if(toRelate is null) return;
        
        toRelate.userIdentifier = userIdentifier;
    }


    public async Task Flush() => await context.SaveChangesAsync();
}