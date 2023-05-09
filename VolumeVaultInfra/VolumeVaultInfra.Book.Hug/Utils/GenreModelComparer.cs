using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Utils;

public class GenreModelComparer : IEqualityComparer<GenreModel>
{
    public bool Equals(GenreModel x, GenreModel y) => x.genre == y.genre;

    public int GetHashCode(GenreModel obj)
    {
        return HashCode.Combine(obj.id, obj.genre);
    }
}