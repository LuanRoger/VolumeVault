using AutoMapper;
using FluentValidation;
using FluentValidation.Results;
using Grpc.Core;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Utils;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Hug.Services;

public class BookService : Hug.BookService.BookServiceBase
{
    private ILogger logger { get; }
    private IBookRepository bookRepository { get; }
    private IGenreRepository genreRepository { get; }
    private ITagRepository tagRepository { get; }
    private IUserIdentifierRepository userIdentifierRepository { get; }
    private IMapper mapper { get; }
    private IValidator<BookWriteModel> bookWriteValidation { get; }

    public BookService(ILogger logger, IBookRepository bookRepository,
        IGenreRepository genreRepository, IUserIdentifierRepository userIdentifierRepository, 
        ITagRepository tagRepository, IMapper mapper, IValidator<BookWriteModel> bookWriteValidation)
    {
        this.logger = logger;
        this.bookRepository = bookRepository;
        this.mapper = mapper;
        this.bookWriteValidation = bookWriteValidation;
        this.tagRepository = tagRepository;
        this.userIdentifierRepository = userIdentifierRepository;
        this.genreRepository = genreRepository;
    }

    public override async Task<GrpcBookModel> CreateBook(CreateBookRequest request, ServerCallContext context)
    {
        BookWriteModel writeModel = mapper.Map<BookWriteModel>(request.Book);
        ValidationResult validationResult = await bookWriteValidation.ValidateAsync(writeModel);
        if(!validationResult.IsValid)
        {
            NotValidBookInformationException exception = new(validationResult
                .Errors
                .Select(e => e.ErrorMessage));
            logger.Error(exception, "Invalid book info");
            
            throw new RpcException(new(StatusCode.InvalidArgument, exception.Message));
        }
        UserIdentifier? user = await userIdentifierRepository.EnsureInMirror(new() 
            { userIdentifier = request.UserId});
        if(user is null)
        {
            UserDoesNotExistsException exception = new(request.UserId);
            logger.Error(exception, "The user is not mirroed on this databse");
            
            throw new RpcException(new(StatusCode.Unavailable, exception.Message));
        }
        
        BookModel bookToRegister = mapper.Map<BookModel>(writeModel);
        bookToRegister.owner = user;
        BookModel newBook = await bookRepository.AddBook(bookToRegister);
        GrpcBookModel grpcBookModel = mapper.Map<GrpcBookModel>(newBook);

        if(writeModel.genre is not null)
        {
            await FlushBookGenres(writeModel.genre, newBook, user);
            grpcBookModel.Genre.AddRange(writeModel.genre);
        }
        if(writeModel.tags is not null)
        {
            await FlushBookTags(writeModel.tags, newBook);
            grpcBookModel.Tags.AddRange(writeModel.genre);
        }
        
        await bookRepository.Flush();

        return grpcBookModel;
    }

    public override async Task GetBooks(GetBooksRequest request, IServerStreamWriter<GrpcBookModel> responseStream, ServerCallContext context)
    {
        UserIdentifier user = await userIdentifierRepository.EnsureInMirror(new() { userIdentifier = request.UserId});
        var bookResults = await bookRepository.GetUserOwnedBooksSplited(user, request.Page, request.LimitPerPage, new()
        {
            sortOptions = GrpcEnumConverter.ToBookSort(request.SortOption),
            ascending = request.Ascending
        });

        foreach (BookModel book in bookResults)
        {
            GrpcBookModel grpcBookModel = mapper.Map<GrpcBookModel>(book);
            var bookGenres = await genreRepository.GetBookGenres(book);
            var bookTags = await tagRepository.GetBookTags(book);
            
            grpcBookModel.Genre.AddRange(bookGenres.Select(genre => genre.genre));
            grpcBookModel.Tags.AddRange(bookTags.Select(tag => tag.tag));

            await responseStream.WriteAsync(grpcBookModel);
        }
    }

    private async Task FlushBookGenres(IEnumerable<string> genres, BookModel book, UserIdentifier user)
    {
        var genresModels = genres.Select(genre => new GenreModel
        {
            genre = genre
        });

        await genreRepository.AddGenreRange(genresModels, book, user);
    }
    
    private async Task FlushBookTags(IEnumerable<string> tags, BookModel book)
    {
        var tagModels = tags.Select(tag => new TagModel
        {
            tag = tag
        });

        await tagRepository.AddTagRange(tagModels, book);
    }
}