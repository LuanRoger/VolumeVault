namespace VolumeVaultInfra.Models.Book;

public class BookUserRelatedReadModel
{
    public int page { get; init; }
    public int limitPerPage { get; init; }
    public int countInPage { get; init; }
    public IReadOnlyList<BookReadModel> books { get; init; }
}