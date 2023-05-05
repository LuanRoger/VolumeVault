using VolumeVaultInfra.Models.Enums;
using VolumeVaultInfra.Models.Utils;

namespace VolumeVaultInfra.Test.ControllersTests.BookControllerTests.FakeData;

public static class BookUtilsFakeModels
{
    public static BookSortOptions defaultBookSortOptions => new()
    {
        sortOptions = BookSort.Title,
        ascending = true
    };
}