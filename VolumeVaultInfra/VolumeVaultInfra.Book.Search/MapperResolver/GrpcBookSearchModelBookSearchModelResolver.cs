using AutoMapper;
using VolumeVaultInfra.Book.Search.Models;

namespace VolumeVaultInfra.Book.Search.MapperResolver;

public class GrpcBookSearchModelBookSearchModelResolver : ITypeConverter<GrpcBookSearchModel, BookSearchModel>
{
    public BookSearchModel Convert(GrpcBookSearchModel source, BookSearchModel destination,
        ResolutionContext context) => new()
    {
        id = source.Id,
        title = source.Title,
        author = source.Author,
        isbn = source.Isbn,
        publicationYear = source.HasPublicationYear ? source.PublicationYear : null,
        publisher = source.HasPublisher ? source.Publisher : null,
        edition = source.HasEdition ? source.Edition : null,
        pagesNumber = source.HasPagesNumber ? source.PagesNumber : null,
        genre = source.Genre is null || source.Genre.Count == 0 ? null : source.Genre.ToList(),
        format = source.HasFormat ? source.Format : null,
        readStatus = source.HasReadStatus ? source.ReadStatus : null,
        readStartDay = source.ReadStartDay is null ? null : 
            new(source.ReadStartDay.Year, source.ReadStartDay.Month, source.ReadStartDay.Day),
        readEndDay = source.ReadEndDay is null ? null : 
            new(source.ReadEndDay.Year, source.ReadEndDay.Month, source.ReadEndDay.Day),
        tags = source.Tags is null || source.Tags.Count == 0 ? null : source.Tags.ToList(),
        createdAt = new(source.CreatedAt.Year, source.CreatedAt.Month, source.CreatedAt.Day),
        lastModification = new(source.LastModification.Year, source.LastModification.Month, source.LastModification.Day),
        ownerId = source.OwnerId
    };
}