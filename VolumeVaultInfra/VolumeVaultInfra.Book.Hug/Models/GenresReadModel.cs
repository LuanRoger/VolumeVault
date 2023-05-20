namespace VolumeVaultInfra.Book.Hug.Models;

public class GenresReadModel
{
    public required int count { get; init; }
    public IReadOnlyList<string> genres { get; }

    public GenresReadModel(IReadOnlyList<string> genres)
    {
        this.genres = genres;
    }
}