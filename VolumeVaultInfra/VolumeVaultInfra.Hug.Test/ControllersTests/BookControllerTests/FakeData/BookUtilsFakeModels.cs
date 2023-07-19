using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Enums;
using VolumeVaultInfra.Book.Hug.Models.Utils;

namespace VolumeVaultInfra.Hug.Test.ControllersTests.BookControllerTests.FakeData;

public static class BookUtilsFakeModels
{
    public static BookSortOptions defaultBookSortOptions => new()
    {
        sortOptions = BookSort.Title,
        ascending = true
    };
    public static BookResultLimiter defaultBookResultLimiter => new()
    {
        genres = null,
        bookFormat = null
    };
    
    public static IReadOnlyList<GenreModel> bookGenres => new List<GenreModel> { 
        new()
        {
            id = 0,
            genre = "Magic" 
        } , 
        new()
        {
            id = 1,
            genre = "Fantasy"
        }, new()
        {
            id = 2,
            genre = "Test"
        }
    };
    
    public static IReadOnlyList<TagModel> bookTags => new List<TagModel>
    {
        new()
        {
            id = 0,
            tag = "Test"
        },
        new()
        {
            id = 1,
            tag = "Test"
        },
        new()
        {
            id = 2,
            tag = "Test"
        }
    };
}