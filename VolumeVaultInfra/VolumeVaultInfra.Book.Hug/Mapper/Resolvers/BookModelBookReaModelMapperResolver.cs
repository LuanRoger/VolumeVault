using AutoMapper;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Mapper.Resolvers;

public class BookModelBookReaModelMapperResolver : ITypeConverter<BookModel, BookReadModel>
{
    public BookReadModel Convert(BookModel source, BookReadModel destination, ResolutionContext context) =>
    new()
    {
        id = source.id,
        title = source.title,
        author = source.author,
        isbn = source.isbn,
        publicationYear = source.publicationYear,
        publisher = source.publisher,
        edition = source.edition,
        pagesNumber = source.pagesNumber,
        format = source.format,
        observation = source.observation,
        synopsis = source.synopsis,
        coverLink = source.coverLink,
        buyLink = source.buyLink,
        readStatus = source.readStatus,
        readStartDay = source.readStartDay,
        readEndDay = source.readEndDay,
        lastModification = source.lastModification,
        createdAt = source.createdAt,
        owner = source.owner
    };
}