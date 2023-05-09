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
    
    public async Task AddTagRange(IEnumerable<TagModel> tags, BookModel book)
    {
        List<BookTagModel> bookTagRelation = new();
        foreach (TagModel tag in tags)
        {
            TagModel? newTag = await tagDb.tags.FirstOrDefaultAsync(dbTag => dbTag.tag == tag.tag);;
            newTag ??= (await tagDb.tags.AddAsync(tag)).Entity;
            
            bookTagRelation.Add(new()
            {
                book = book,
                tag = newTag
            });
        }
        
        await tagDb.bookTag.AddRangeAsync(bookTagRelation);
    }

    public async Task<IReadOnlyList<TagModel>> GetBookTags(BookModel book) =>
     await tagDb.bookTag
         .Where(relation => relation.book == book)
         .Select(relation => relation.tag)
         .ToListAsync();

    public async Task DeleteAllTagsFromBook(BookModel book)
    {
        var tagsToRemove = await tagDb.bookTag
            .Where(relation => relation.book == book)
            .ToListAsync();
        
        tagDb.bookTag.RemoveRange(tagsToRemove);
    }
}