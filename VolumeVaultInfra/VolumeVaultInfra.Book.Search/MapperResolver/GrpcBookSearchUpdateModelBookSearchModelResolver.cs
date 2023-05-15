using AutoMapper;
using VolumeVaultInfra.Book.Search.Models;

namespace VolumeVaultInfra.Book.Search.MapperResolver;

public class GrpcBookSearchUpdateModelBookSearchModelResolver : 
    ITypeConverter<GrpcBookSearchUpdateModel, BookSearchUpdateModel>
{
    public BookSearchUpdateModel Convert(GrpcBookSearchUpdateModel source, BookSearchUpdateModel destination,
        ResolutionContext context) => new()
    {
        title = source.HasTitle ? source.Title : null,
        author = source.HasAuthor ? source.Author : null,
        isbn = source.HasIsbn ? source.Isbn : null,
        publicationYear = source.HasPublicationYear ? source.PublicationYear : null,
        publisher = source.HasPublisher ? source.Publisher : null,
        edition = source.HasEdition ? source.Edition : null,
        pagesNumber = source.HasPagesNumber ? source.PagesNumber : null,
        genre = source.HasGenre ? source.Genre : null,
        format = source.HasFormat ? source.Format : null,
        readStatus = source.HasReadStatus ? source.ReadStatus : null,
        readStartDay = source.ReadStartDay is null ? null : 
            new(source.ReadStartDay.Year, source.ReadStartDay.Month, source.ReadStartDay.Day),
        readEndDay = source.ReadEndDay is null ? null : 
            new(source.ReadEndDay.Year, source.ReadEndDay.Month, source.ReadEndDay.Day),
        tags = source.Tags is null || source.Tags.Count == 0 ? null : source.Tags.ToList(),
        lastModification = new(source.LastModification.Year, source.LastModification.Month, source.LastModification.Day)
    };
}