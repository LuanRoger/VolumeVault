using AutoMapper;
using FluentValidation;
using FluentValidation.Results;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Repositories;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Hug.Controller;

public class BookController : IBookController
{
    private ILogger logger { get; }
    private IBookRepository bookRepository { get; }
    private IGenreRepository genreRepository { get; }
    private ITagRepository tagRepository { get; }
    private IUserIdentifierRepository userIdentifierRepository { get; }
    private IMapper mapper { get; }
    private IValidator<BookWriteModel> bookWriteValidation { get; }

    public BookController(ILogger logger, IBookRepository bookRepository,
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

    public async Task<int> CreateBook(BookWriteModel bookWrite, string userId)
    {
        UserIdentifier user = await userIdentifierRepository.EnsureInMirror(new() 
            { userIdentifier = userId});
        
        ValidationResult validationResult = await bookWriteValidation.ValidateAsync(bookWrite);
        if(!validationResult.IsValid)
        {
            NotValidBookInformationException exception = new(validationResult
                .Errors
                .Select(e => e.ErrorMessage));
            logger.Error(exception, "Invalid book info");
            
            throw exception;
        }
        if(user is null)
        {
            UserDoesNotExistsException exception = new(userId);
            logger.Error(exception, "The user is not mirroed on this databse");
            
            throw exception;
        }
        
        BookModel bookToRegister = mapper.Map<BookModel>(bookWrite);
        bookToRegister.owner = user;
        
        BookModel newBook = await bookRepository.AddBook(bookToRegister);

        if(bookWrite.genre is not null)
            await FlushBookGenres(bookWrite.genre, newBook, user);
        if(bookWrite.tags is not null)
            await FlushBookTags(bookWrite.tags, newBook);
        
        await bookRepository.Flush();

        return newBook.id;
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