using AutoMapper;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Utils;

namespace VolumeVaultInfra.Book.Hug.Mapper.Resolvers;

public class GrpcBookWriteModelBookWriteModelMapperResolver : ITypeConverter<GrpcBookWriteModel, BookWriteModel>
{
    public BookWriteModel Convert(GrpcBookWriteModel source, BookWriteModel destination,
        ResolutionContext context) => new()
    {
        title = source.Title,
        author = source.Author,
        isbn = source.Isbn,
        publicationYear = source.HasPublisher ? source.PublicationYear : null,
        publisher = source.HasPublisher ? source.Publisher : null,
        edition = source.HasEdition ? source.Edition : null,
        pagesNumber = source.HasPagesNumber ? source.PagesNumber : null,
        genre = source.Genre is not null && source.Genre.Count != 0 ? source.Genre.ToList() : null,
        format = source.HasFormat ? GrpcEnumConverter.ToBookFormat(source.Format) : null,
        observation = source.HasObservations ? source.Observations : null,
        synopsis =  source.HasSynopsis ? source.Synopsis : null,
        coverLink = source.HasCoverLink ? source.CoverLink : null,
        buyLink = source.HasBuyLink ? source.BuyLink : null,
        readStatus = source.HasReadStatus ? GrpcEnumConverter.ToReadStatus(source.ReadStatus) : null,
        readStartDay = source.ReadStartDay is null ? null : 
            new(source.ReadStartDay.Year, source.ReadStartDay.Month, source.ReadStartDay.Day),
        readEndDay = source.ReadEndDay is null ? null : 
            new(source.ReadEndDay.Year, source.ReadEndDay.Month, source.ReadEndDay.Day),
        tags = source.Tags is not null && source.Tags.Count != 0 ? source.Tags.ToList() : null
    };
}