namespace VolumeVaultInfra.Book.Search.Models;

public class SearchRepositoryResult
{
    public IReadOnlyList<BookSearchModel> hints { get; init; }
    public TimeSpan searchElapsedTime { get; init; }
    public string query { get; init; }
}