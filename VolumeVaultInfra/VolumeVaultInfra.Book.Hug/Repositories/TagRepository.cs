using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public class TagRepository : ITagRepository
{
    private DatabaseContext tagDb { get; }

    public TagRepository(DatabaseContext tagDb)
    {
        this.tagDb = tagDb;
    }
    
    public async Task RelateBookTagRange(IEnumerable<TagModel> tags, BookModel book)
    {
        foreach (TagModel tag in tags)
            await RelateBookTag(tag, book);
    }

    public async Task<TagModel> RelateBookTag(TagModel tag, BookModel book)
    {
        TagModel? newTag = await tagDb.tags.FirstOrDefaultAsync(dbTag => dbTag.tag == tag.tag);;
        newTag ??= (await tagDb.tags.AddAsync(tag)).Entity;
            
        BookTagModel bookTagModel = new()
        {
            book = book,
            tag = newTag
        };
        
        await tagDb.bookTag.AddAsync(bookTagModel);
        
        return newTag;
    }

    public async Task<IReadOnlyList<TagModel>> GetBookTags(BookModel book) =>
     await tagDb.bookTag
         .Where(relation => relation.book == book)
         .Select(relation => relation.tag)
         .ToListAsync();

    public async Task RemoveAllTagsRalationWithBook(BookModel book)
    {
        var tagsToRemove = await tagDb.bookTag
            .Where(relation => relation.book == book)
            .ToListAsync();
        
        tagDb.bookTag.RemoveRange(tagsToRemove);
    }
}