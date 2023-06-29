using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface IEmailUserIdentifierRepository
{
    public Task<EmailUserIdentifier> EnsureEmailExists(EmailUserIdentifier? emailUserIdentifier);
    public Task RelateToUser(string emailUserIdentifier, UserIdentifier userIdentifier);

    public Task Flush();
}