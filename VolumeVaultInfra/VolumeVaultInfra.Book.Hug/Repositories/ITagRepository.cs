using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public interface ITagRepository
{
    public Task AddTagRange(IEnumerable<TagModel> tags, BookModel book);
    public Task<IReadOnlyList<TagModel>> GetBookTags(BookModel book);
    public Task DeleteAllTagsFromBook(BookModel book);
}