using VolumeVaultInfra.Book.Hug.Models.Enums;

namespace VolumeVaultInfra.Book.Hug.Utils;

internal static class GrpcEnumConverter
{
    internal static BookFormat ToBookFormat(GrpcBookFormat grpcBookFormat) => grpcBookFormat switch
    {
        GrpcBookFormat.Hardcover => BookFormat.HARDCOVER,
        GrpcBookFormat.Hardback => BookFormat.HARDBACK,
        GrpcBookFormat.Paperback => BookFormat.PAPERBACK,
        GrpcBookFormat.Ebook => BookFormat.EBOOK,
        _ => throw new ArgumentOutOfRangeException(nameof(grpcBookFormat), grpcBookFormat, null)
    };
    internal static GrpcBookFormat FromBookFormat(BookFormat format) => format switch
    {
        BookFormat.HARDCOVER => GrpcBookFormat.Hardcover,
        BookFormat.HARDBACK => GrpcBookFormat.Hardback,
        BookFormat.PAPERBACK => GrpcBookFormat.Paperback,
        BookFormat.EBOOK => GrpcBookFormat.Ebook,
        _ => throw new ArgumentOutOfRangeException(nameof(format), format, null)
    };
    internal static ReadStatus ToReadStatus(GrpcReadStatus grpcReadStatus) => grpcReadStatus switch
    {
        GrpcReadStatus.NotRead => ReadStatus.HasReaded,
        GrpcReadStatus.Reading => ReadStatus.Reading,
        GrpcReadStatus.HasReaded => ReadStatus.HasReaded,
        _ => throw new ArgumentOutOfRangeException(nameof(grpcReadStatus), grpcReadStatus, null)
    };
    internal static GrpcReadStatus FromReadStatus(ReadStatus readStatus) => readStatus switch
    {
        ReadStatus.HasReaded => GrpcReadStatus.HasReaded,
        ReadStatus.Reading => GrpcReadStatus.Reading,
        ReadStatus.NotRead => GrpcReadStatus.NotRead,
        _ => throw new ArgumentOutOfRangeException(nameof(readStatus), readStatus, null)
    };
    internal static BookSort ToBookSort(GrpcBookSort grpcBookSort) => grpcBookSort switch
    {
        GrpcBookSort.Title => BookSort.Title,
        GrpcBookSort.Author => BookSort.Author,
        GrpcBookSort.ReleaseDate => BookSort.ReleaseDate,
        GrpcBookSort.Publisher => BookSort.Publisher,
        GrpcBookSort.Genre => BookSort.Genre,
        GrpcBookSort.Pages => BookSort.Pages,
        GrpcBookSort.ReadStartDay => BookSort.ReadStartDay,
        GrpcBookSort.ReadEndDay => BookSort.ReadEndDay,
        GrpcBookSort.CreationDate => BookSort.CreationDate,
        _ => throw new ArgumentOutOfRangeException(nameof(grpcBookSort), grpcBookSort, null)
    };
}