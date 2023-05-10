using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface ITagRepository
{
    public Task RelateBookTagRange(IEnumerable<TagModel> tags, BookModel book);
    public Task<TagModel> RelateBookTag(TagModel tag, BookModel book);
    public Task<IReadOnlyList<TagModel>> GetBookTags(BookModel book);
    public Task RemoveAllTagsRalationWithBook(BookModel book);
}