using FluentValidation;
using FluentValidation.Results;
using VolumeVaultInfra.Book.Exceptions;
using VolumeVaultInfra.Book.Models.Book;
using VolumeVaultInfra.Book.Models.Utils;
using VolumeVaultInfra.Book.Repositories;
using VolumeVaultInfra.Book.Services.Metrics;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Book.Controllers;

public class BookController : IBookController
{
    private IBookRepository _bookRepository { get; }
    private IBookSearchRepository _searchRepository { get; }
    private IBookControllerMetrics _metrics { get; }
    private IValidator<BookWriteModel> _bookWriteModelValidator { get; }
    private IValidator<BookUpdateModel> _bookUpdateModelValidator { get; }
    private ILogger _logger { get; }

    public BookController(IBookRepository bookRepository,
        IBookSearchRepository searchRepository,
        IBookControllerMetrics metrics,
        IValidator<BookWriteModel> bookWriteModelValidator,
        IValidator<BookUpdateModel> bookUpdateModelValidator,
        ILogger logger)
    {
        _bookRepository = bookRepository;
        _searchRepository = searchRepository;
        _metrics = metrics;
        _bookWriteModelValidator = bookWriteModelValidator;
        _bookUpdateModelValidator = bookUpdateModelValidator;
        _logger = logger;
    }
    
    public async Task<BookReadModel> GetBookById(string userId, int bookId)
    {
        _logger.Information("Getting book ID[{0}] owned by {1}", 
            bookId, userId);
        BookModel? book = await _bookRepository.GetBookById(bookId);
        if(book is null)
        {
            Exception ex = new BookNotFoundException(bookId);
            _logger.Error(ex, ex.Message);
            throw ex;
        }

        _logger.Information("Found Title[{0}]. Sending book...", book.title);
        BookReadModel bookReadModel = BookReadModel.FromBookModel(book);
        return bookReadModel;
    }
    public async Task<IReadOnlyList<string>> GetBooksGenre(string userId)
    {
        return await _bookRepository.GetUserBooksGenres(userId);
    }
    
    public async Task<BookReadModel> RegisterNewBook(string userId, BookWriteModel book)
    {
        ValidationResult validationResult = await _bookWriteModelValidator.ValidateAsync(book);
        if(!validationResult.IsValid)
        {
            Exception ex = new NotValidBookInformationException(validationResult
                .Errors
                .Select(errors => errors.ErrorMessage));
            _logger.Error(ex, ex.Message);
            throw ex;
        }
        _logger.Information("Registering a new book: Title {0}.", book.title);
        
        _logger.Information("The book will be owner by ID {0}.", userId);

        BookModel newBook = new()
        {
            title = book.title,
            author = book.author,
            isbn = book.isbn,
            publicationYear = book.publicationYear,
            publisher = book.publisher,
            edition = book.edition,
            pagesNumber = book.pagesNumber,
            genre = book.genre,
            format = book.format,
            observation = book.observation,
            synopsis = book.synopsis,
            coverLink = book.coverLink,
            buyLink = book.buyLink,
            readStatus = book.readStatus,
            readStartDay = book.readStartDay,
            readEndDay = book.readEndDay,
            tags = book.tags,
            createdAt = book.createdAt,
            lastModification = book.lastModification,
            owner = userId.ToString()
        };
        BookModel registeredBook = await _bookRepository.AddBook(newBook);
        await _bookRepository.Flush();
        await _searchRepository.MadeBookSearchable(BookSearchModel.FromBookModel(registeredBook));

        _metrics.IncreaseExistingBooks();
        _metrics.IncreaseRegisteredBooks();
        if(registeredBook.pagesNumber is not null) _metrics.ObserverBookPageNumber(registeredBook.pagesNumber);
        _logger.Information("Book [{0}] registered sucessfully.", registeredBook.id);
        
        return BookReadModel.FromBookModel(registeredBook);
    }

    public async Task<BookUserRelatedReadModel> GetAllUserReleatedBooks(string userId, int page, int limitPerPage, BookSortOptions? bookSortOptions)
    {
        _logger.Information("Getting books from user ID[{0}].", userId);
        _logger.Information("{0}: {1}, {2}: {3}", nameof(page), page,
            nameof(limitPerPage), limitPerPage);

        _logger.Information("Geting results from database.");
        IReadOnlyList<BookReadModel> userBooks = 
            (await _bookRepository.GetUserOwnedBooksSplited(userId, page, limitPerPage, bookSortOptions))
            .Select(BookReadModel.FromBookModel).ToList();
        
        BookUserRelatedReadModel userRelatedBooks = new()
        {
            page = page,
            limitPerPage = limitPerPage,
            countInPage = userBooks.Count,
            books = userBooks
        };
        
        return userRelatedBooks;
    }

    public async Task<IReadOnlyList<BookSearchReadModel>> SearchBook(string userId, string searchQuery, int limitPerPage)
    {
        var searchResults = await _searchRepository.SearchBook(userId, searchQuery, limitPerPage);
        var filteredResult = 
            from book in searchResults where book.ownerId == userId select book;

        var searchReadResults = filteredResult
            .Select(BookSearchReadModel.FromSearchModel)
            .ToList();
        
        return searchReadResults;
    }

    public async Task UpdateBook(string userId, int bookId, BookUpdateModel bookUpdate)
    {
        ValidationResult validationResult = await _bookUpdateModelValidator.ValidateAsync(bookUpdate);
        if(!validationResult.IsValid)
        {
            Exception ex = new NotValidBookInformationException(validationResult
                .Errors
                .Select(errors => errors.ErrorMessage)); 
            _logger.Error(ex, ex.Message);
            throw ex;
        }

        BookModel? book = await _bookRepository.GetBookById(bookId);
        if(book is null)
        {
            Exception ex = new BookNotFoundException(bookId);
            _logger.Error(ex, ex.Message);
            throw ex;
        }
        _logger.Information("Updating book ID[{0}]", book.id);
        bool hasBeenModified = false;
        
        if(bookUpdate.title is not null)
        {
            book.title = bookUpdate.title;
            hasBeenModified = true;
        }
        if(bookUpdate.author is not null)
        {
            book.author = bookUpdate.author;
            hasBeenModified = true;
        }
        if(bookUpdate.isbn is not null)
        {
            book.isbn = bookUpdate.isbn;
            hasBeenModified = true;
        }
        if(bookUpdate.publicationYear is not null)
        {
            book.publicationYear = bookUpdate.publicationYear;
            hasBeenModified = true;
        }
        if(bookUpdate.publisher is not null)
        {
            book.publisher = bookUpdate.publisher;
            hasBeenModified = true;
        }
        if(bookUpdate.edition is not null)
        {
            book.edition = bookUpdate.edition;
            hasBeenModified = true;
        }
        if(bookUpdate.pagesNumber is not null)
        {
            book.pagesNumber = bookUpdate.pagesNumber;
            hasBeenModified = true;
        }
        if(bookUpdate.genre is not null)
        {
            book.genre = bookUpdate.genre;
            hasBeenModified = true;
        }
        if(bookUpdate.format is not null)
        {
            book.format = bookUpdate.format;
            hasBeenModified = true;
        }
        if(bookUpdate.observation is not null)
        {
            book.observation = bookUpdate.observation;
            hasBeenModified = true;
        }
        if(bookUpdate.synopsis is not null)
        {
            book.synopsis = bookUpdate.synopsis;
            hasBeenModified = true;
        }
        if(bookUpdate.coverLink is not null)
        {
            book.coverLink = bookUpdate.coverLink;
            hasBeenModified = true;
        }
        if(bookUpdate.buyLink is not null)
        {
            book.buyLink = bookUpdate.buyLink;
            hasBeenModified = true;
        }
        if(bookUpdate.readStatus is not null)
        {
            book.readStatus = bookUpdate.readStatus;
            hasBeenModified = true;
        }
        if(bookUpdate.readStartDay is not null)
        {
            book.readStartDay = bookUpdate.readStartDay;
            hasBeenModified = true;
        }
        if(bookUpdate.readEndDay is not null)
        {
            book.readEndDay = bookUpdate.readEndDay;
            hasBeenModified = true;
        }
        if(bookUpdate.tags is not null)
        {
            book.tags = bookUpdate.tags;
            hasBeenModified = true;
        }
        if(hasBeenModified)
            book.lastModification = bookUpdate.lastModification;

        await _bookRepository.Flush();
        await _searchRepository.UpdateSearchBook(bookId, BookSearchModel.FromBookModel(book));
        _logger.Information("Book ID[{0}] updated.", book.id);
    }
    
    public async Task<int> DeleteBook(string userId, int bookId)
    {
        BookModel? book = await _bookRepository.GetBookById(bookId);
        if(book is null)
        {
            Exception ex = new BookNotFoundException(bookId);
            _logger.Error(ex, ex.Message);
            throw ex;    
        }
        _logger.Information("Deleting book ID[{0}].", book.id);

        BookModel deletedBook = _bookRepository.DeleteBook(book);
        await _bookRepository.Flush();
        await _searchRepository.DeleteBookFromSearch(deletedBook.id);
        
        _metrics.DecreaseExsistingBooks();
        _logger.Information("Book ID[{0}] deleted.", book.id);
        
        return deletedBook.id;
    }
}