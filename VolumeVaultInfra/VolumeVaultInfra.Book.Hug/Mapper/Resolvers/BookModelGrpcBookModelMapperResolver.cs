using AutoMapper;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Utils;

namespace VolumeVaultInfra.Book.Hug.Mapper.Resolvers;

public class BookModelGrpcBookModelMapperResolver : ITypeConverter<BookModel, GrpcBookModel>
{
    public GrpcBookModel Convert(BookModel source, GrpcBookModel destination, ResolutionContext context)
    {
        GrpcBookModel grpcBookModel = new()
        {
            Id = source.id,
            Title = source.title,
            Author = source.author,
            Isbn = source.isbn,
            CreatedAt = new()
            {
                Day = source.createdAt.Day,
                Month = source.createdAt.Month,
                Year = source.createdAt.Year
            },
            LastModification = new()
            {
                Day = source.lastModification.Day,
                Month = source.lastModification.Month,
                Year = source.lastModification.Year
            }
        };
        if(source.publicationYear.HasValue)
            grpcBookModel.PublicationYear = source.publicationYear.Value;
        if(source.publisher is not null)
            grpcBookModel.Publisher = source.publisher;
        if(source.edition.HasValue)
            grpcBookModel.Edition = source.edition.Value;
        if(source.pagesNumber.HasValue)
            grpcBookModel.PagesNumber = source.pagesNumber.Value;
        if(source.format.HasValue)
            grpcBookModel.Format = GrpcEnumConverter.FromBookFormat(source.format.Value);
        if(source.observation is not null)
            grpcBookModel.Observation = source.observation;
        if(source.synopsis is not null)
            grpcBookModel.Synopsis = source.synopsis;
        if(source.coverLink is not null)
            grpcBookModel.CoverLink = source.coverLink;
        if(source.buyLink is not null)
            grpcBookModel.BuyLink = source.buyLink;
        if(source.readStatus.HasValue)
            grpcBookModel.ReadStatus = GrpcEnumConverter.FromReadStatus(source.readStatus.Value);
        if(source.readStartDay.HasValue)
        {
            Date grpcDate = new()
            {
                Day = source.readStartDay.Value.Day,
                Month = source.readStartDay.Value.Month,
                Year = source.readStartDay.Value.Year
            };
            grpcBookModel.ReadStartDay = grpcDate;
        }
        // ReSharper disable once InvertIf
        if(source.readEndDay.HasValue)
        {
            Date grpcDate = new()
            {
                Day = source.readEndDay.Value.Day,
                Month = source.readEndDay.Value.Month,
                Year = source.readEndDay.Value.Year
            };
            grpcBookModel.ReadEndDay = grpcDate;
        }
        
        return grpcBookModel;
    }
}