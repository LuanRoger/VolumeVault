namespace VolumeVaultInfra.Book.Search.Models;

public class SearchResultModel
{
    public int count { get; init; }
    public TimeSpan searchElapsedTime { get; init; }
    public required IReadOnlyList<BookSearchModel> results { get; init; }
}