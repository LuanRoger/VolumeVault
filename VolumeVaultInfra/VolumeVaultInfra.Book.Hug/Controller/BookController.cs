using AutoMapper;
using FluentValidation;
using FluentValidation.Results;
using VolumeVaultInfra.Book.Hug.Exceptions;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;
using VolumeVaultInfra.Book.Hug.Models.Utils;
using VolumeVaultInfra.Book.Hug.Repositories;
using VolumeVaultInfra.Book.Hug.Repositories.Search;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Hug.Controller;

public class BookController : IBookController
{
    private ILogger logger { get; }
    private IBookRepository bookRepository { get; }
    private IGenreRepository genreRepository { get; }
    private ITagRepository tagRepository { get; }
    private IUserIdentifierRepository userIdentifierRepository { get; }
    private IBookSearchRepository? searchRepository { get; }
    private IMapper mapper { get; }
    private IValidator<BookWriteModel> bookWriteValidation { get; }
    private IValidator<BookUpdateModel> bookUpdateValidation { get; }

    public BookController(ILogger logger, IBookRepository bookRepository,
        IGenreRepository genreRepository, IUserIdentifierRepository userIdentifierRepository, 
        ITagRepository tagRepository, IBookSearchRepository? searchRepository, IMapper mapper, IValidator<BookWriteModel> bookWriteValidation,
        IValidator<BookUpdateModel> bookUpdateValidation)
    {
        this.logger = logger;
        this.bookRepository = bookRepository;
        this.mapper = mapper;
        this.bookWriteValidation = bookWriteValidation;
        this.bookUpdateValidation = bookUpdateValidation;
        this.tagRepository = tagRepository;
        this.userIdentifierRepository = userIdentifierRepository;
        this.genreRepository = genreRepository;
        this.searchRepository = searchRepository;
    }

    public async Task<BookReadModel> GetBook(int bookId, string userId)
    {
        UserIdentifier user = await userIdentifierRepository.EnsureInMirror(new() 
            {userIdentifier = userId});
        BookModel? bookResult = await bookRepository.GetBookById(bookId);
        if(bookResult is null)
        {
            BookNotFoundException exception = new(bookId);
            logger.Error(exception, "Book not found");
            
            throw exception;
        }
        if(bookResult.owner != user)
        {
            NotOwnerBookException exception = new(bookResult.title, user.userIdentifier);
            logger.Error(exception, "User is not the owner of the book");
            
            throw exception;
        }
        
        BookReadModel readModel = mapper.Map<BookReadModel>(bookResult);
        return readModel;
    }

    public async Task<BookUserRelatedReadModel> GetUserOwnedBook(string userId, int page, int limitPerPage, 
        BookSortOptions? sort)
    {
        UserIdentifier user = await userIdentifierRepository.EnsureInMirror(new()
        { userIdentifier = userId });
        var booksResult = await bookRepository
            .GetUserOwnedBooksSplited(user, page, limitPerPage, sort);
        var readModels = booksResult
            .Select(result => mapper.Map<BookReadModel>(result))
            .ToList();
        
        return new()
        {
            page = page,
            limitPerPage = limitPerPage,
            countInPage = readModels.Count,
            books = readModels
        };
    }

    public async Task<int> CreateBook(BookWriteModel writeModel, string userId)
    {
        UserIdentifier user = await userIdentifierRepository.EnsureInMirror(new() 
            { userIdentifier = userId});
        
        ValidationResult validationResult = await bookWriteValidation.ValidateAsync(writeModel);
        if(!validationResult.IsValid)
        {
            NotValidBookInformationException exception = new(validationResult
                .Errors
                .Select(e => e.ErrorMessage));
            logger.Error(exception, "Invalid book info");
            
            throw exception;
        }

        BookModel bookToRegister = mapper.Map<BookModel>(writeModel);
        bookToRegister.owner = user;
        
        BookModel newBook = await bookRepository.AddBook(bookToRegister);

        if(writeModel.genre is not null)
            await FlushBookGenres(writeModel.genre, newBook, user);
        if(writeModel.tags is not null)
            await FlushBookTags(writeModel.tags, newBook);
        
        await bookRepository.Flush();
        
        // ReSharper disable once InvertIf
        if(searchRepository is not null)
        {
            BookSearchModel searchModel = mapper.Map<BookSearchModel>(writeModel);
            searchModel.id = newBook.id;
            searchModel.ownerId = user.userIdentifier;
            await searchRepository.MadeBookSearchable(searchModel);
        }

        return newBook.id;
    }

    public async Task<int> UpdateBook(BookUpdateModel updateModel, int bookId, string userId)
    {
        ValidationResult result = await bookUpdateValidation.ValidateAsync(updateModel);
        if(!result.IsValid)
        {
            NotValidBookInformationException exception = new(result.Errors
                .Select(e => e.ErrorMessage));
            logger.Error(exception, "Invalid book info");
            
            throw exception;
        }
        UserIdentifier user = await userIdentifierRepository
            .EnsureInMirror(new() { userIdentifier = userId});
        BookModel? bookToUpdate = await bookRepository.GetBookById(bookId);
        if(bookToUpdate is null)
        {
            BookNotFoundException exception = new(bookId);
            logger.Error(exception, "Book does not exists");
            
            throw exception;
        }
        if(bookToUpdate.owner.id != user.id)
        {
            NotOwnerBookException exception = new(bookToUpdate.title, user.userIdentifier);
            logger.Error(exception, "Book does not belongs to user");
            
            throw exception;
        }
        
        bool hasBeenModified = false;

        if(updateModel.title is not null)
        {
            bookToUpdate.title = updateModel.title;
            hasBeenModified = true;
        }
        if(updateModel.author is not null)
        {
            bookToUpdate.author = updateModel.author;
            hasBeenModified = true;
        }
        if(updateModel.isbn is not null)
        {
            bookToUpdate.isbn = updateModel.isbn;
            hasBeenModified = true;
        }
        if(updateModel.publicationYear is not null)
        {
            bookToUpdate.publicationYear = updateModel.publicationYear;
            hasBeenModified = true;
        }
        if(updateModel.publisher is not null)
        {
            bookToUpdate.publisher = updateModel.publisher;
            hasBeenModified = true;
        }
        if(updateModel.edition is not null)
        {
            bookToUpdate.edition = updateModel.edition;
            hasBeenModified = true;
        }
        if(updateModel.pagesNumber is not null)
        {
            bookToUpdate.pagesNumber = updateModel.pagesNumber;
            hasBeenModified = true;
        }
        if(updateModel.genre is not null)
        {
            await genreRepository.RemoveAllGenreRalationWithBook(bookToUpdate);
            var genreToAdd = updateModel.genre
                .Select(genre => new GenreModel
            {
                genre = genre
            });
            await genreRepository.RelateBookGenreRange(genreToAdd, bookToUpdate, user);
            hasBeenModified = true;
        }
        if(updateModel.format is not null)
        {
            bookToUpdate.format = updateModel.format;
            hasBeenModified = true;
        }
        if(updateModel.observation is not null)
        {
            bookToUpdate.observation = updateModel.observation;
            hasBeenModified = true;
        }
        if(updateModel.synopsis is not null)
        {
            bookToUpdate.synopsis = updateModel.synopsis;
            hasBeenModified = true;
        }
        if(updateModel.coverLink is not null)
        {
            bookToUpdate.coverLink = updateModel.coverLink;
            hasBeenModified = true;
        }
        if(updateModel.buyLink is not null)
        {
            bookToUpdate.buyLink = updateModel.buyLink;
            hasBeenModified = true;
        }
        if(updateModel.readStatus is not null)
        {
            bookToUpdate.readStatus = updateModel.readStatus;
            hasBeenModified = true;
        }
        if(updateModel.readStartDay is not null)
        {
            bookToUpdate.readStartDay = updateModel.readStartDay;
            hasBeenModified = true;
        }
        if(updateModel.readEndDay is not null)
        {
            bookToUpdate.readEndDay = updateModel.readEndDay;
            hasBeenModified = true;
        }
        if(updateModel.tags is not null)
        {
            await tagRepository.RemoveAllTagsRalationWithBook(bookToUpdate);
            var tagsToRelate = updateModel.tags.Select(tag => new TagModel
            {
                tag = tag
            });
            await tagRepository.RelateBookTagRange(tagsToRelate, bookToUpdate);
            hasBeenModified = true;
        }
        if(hasBeenModified)
            bookToUpdate.lastModification = updateModel.lastModification;
        else
        {
            NotModifiedBookException exception = new(bookToUpdate.id);
            logger.Error(exception, "Book has not been modified");
            throw exception;
        }

        await bookRepository.Flush();
        if(searchRepository is not null)
        {
            BookSearchModel bookSearchModel = mapper.Map<BookSearchModel>(updateModel);
            bookSearchModel.id = bookToUpdate.id;
            bookSearchModel.ownerId = user.userIdentifier;
            await searchRepository.UpdateSearchBook(bookId, bookSearchModel);
        }
        logger.Information("Book ID[{BookId}] updated", bookToUpdate.id);
        
        return bookToUpdate.id;
    }
    
    public async Task<int> RemoveBook(int bookId, string userId)
    {
        UserIdentifier userIdentifier = await userIdentifierRepository
            .EnsureInMirror(new() { userIdentifier = userId});
        BookModel? bookToRemove = await bookRepository.GetBookById(bookId);
        if(bookToRemove is null)
        {
            BookNotFoundException exception = new(bookId);
            logger.Error(exception, "Book does not exists");
            
            throw exception;
        }
        if(bookToRemove.owner != userIdentifier)
        {
            NotOwnerBookException exception = new(bookToRemove.title, userIdentifier.userIdentifier);
            logger.Error(exception, "Book does not belongs to user");
            
            throw exception;
        }
        
        BookModel deletedBook = bookRepository.DeleteBook(bookToRemove);
        await bookRepository.Flush();

        // ReSharper disable once InvertIf
        if(searchRepository is not null)
        {
            bool searchDeleteResult = await searchRepository.DeleteBookFromSearch(deletedBook.id);
            if(searchDeleteResult)
                logger.Information("Book ID[{BookId}] deleted from search", deletedBook.id);
            else
                logger.Warning("Book ID[{BookId}] not deleted from search", deletedBook.id);
        }
        
        return deletedBook.id;
    }

    private async Task FlushBookGenres(IEnumerable<string> genres, BookModel book, UserIdentifier user)
    {
        var genresModels = genres.Select(genre => new GenreModel
        {
            genre = genre
        });

        await genreRepository.RelateBookGenreRange(genresModels, book, user);
    }
    
    private async Task FlushBookTags(IEnumerable<string> tags, BookModel book)
    {
        var tagModels = tags.Select(tag => new TagModel
        {
            tag = tag
        });

        await tagRepository.RelateBookTagRange(tagModels, book);
    }
}