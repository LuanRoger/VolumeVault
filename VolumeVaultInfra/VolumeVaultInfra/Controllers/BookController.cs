using FluentValidation;
using FluentValidation.Results;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Services.Metrics;
using ILogger = Serilog.ILogger;

namespace VolumeVaultInfra.Controllers;

public class BookController : IBookController
{
    private IBookRepository _bookRepository { get; }
    private IBookSearchRepository _searchRepository { get; }
    private IUserRepository _userRepository { get; }
    private IBookControllerMetrics _metrics { get; }
    private IValidator<BookWriteModel> _bookWriteModelValidator { get; }
    private IValidator<BookUpdateModel> _bookUpdateModelValidator { get; }
    private ILogger _logger { get; }

    public BookController(IBookRepository bookRepository,
        IBookSearchRepository searchRepository,
        IUserRepository userRepository,
        IBookControllerMetrics metrics,
        IValidator<BookWriteModel> bookWriteModelValidator,
        IValidator<BookUpdateModel> bookUpdateModelValidator,
        ILogger logger)
    {
        _bookRepository = bookRepository;
        _searchRepository = searchRepository;
        _userRepository = userRepository;
        _metrics = metrics;
        _bookWriteModelValidator = bookWriteModelValidator;
        _bookUpdateModelValidator = bookUpdateModelValidator;
        _logger = logger;
    }
    
    //TODO: Return the new book
    public async Task RegisterNewBook(int userId, BookWriteModel book)
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
        
        UserModel? relatedUser = await _userRepository.GetUserById(userId);
        if(relatedUser is null)
        {
            Exception ex = new UserNotFoundException(userId);
            _logger.Error(ex, ex.Message);
            throw ex;
        }
        _logger.Information("The book will be owner by ID {0}.", relatedUser.id);

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
            readed = book.readed,
            tags = book.tags,
            createdAt = book.createdAt,
            owner = relatedUser
        };
        BookModel registeredBook = await _bookRepository.AddBook(newBook);
        await _bookRepository.Flush();
        await _searchRepository.MadeBookSearchable(BookSearchModel.FromBookModel(registeredBook));

        _metrics.IncreaseExistingBooks();
        _metrics.IncreaseRegisteredBooks();
        if(registeredBook.pagesNumber is not null) _metrics.ObserverBookPageNumber(registeredBook.pagesNumber);
        _logger.Information("Book [{0}] registered sucessfully.", registeredBook.id);
    }

    public async Task<List<BookReadModel>> GetAllUserReleatedBooks(int userId, int page, int limitPerPage)
    {
        UserModel? relatedUser = await _userRepository.GetUserById(userId);
        if(relatedUser is null)
        {
            Exception ex = new UserNotFoundException(userId);
            _logger.Error(ex, ex.Message);
            throw ex;
        }
            
        _logger.Information("Getting book from user ID[{0}].", relatedUser.id);
        _logger.Information("{0}: {1}, {2}: {3}.", nameof(page), page,
            nameof(limitPerPage), limitPerPage);

        _logger.Information("Geting results from database.");
        var userBooks = 
            (await _bookRepository.GetUserOwnedBooksSplited(relatedUser.id, page, limitPerPage))
            .Select(bookModel => new BookReadModel
            {
                id = bookModel.id,
                title = bookModel.title,
                author = bookModel.author,
                isbn = bookModel.isbn,
                publicationYear = bookModel.publicationYear,
                publisher = bookModel.publisher,
                edition = bookModel.edition,
                pagesNumber = bookModel.pagesNumber,
                genre = bookModel.genre,
                format = bookModel.format,
                observation = bookModel.observation,
                readed = bookModel.readed,
                tags = bookModel.tags,
                createdAt = bookModel.createdAt,
                owner = new()
                {
                    id = bookModel.owner.id,
                    username = bookModel.owner.username,
                    email = bookModel.owner.email
                },
            }).ToList();

        return userBooks;
    }

    public async Task<List<BookReadModel>> SearchBookParameters(int userId, string searchQuery)
    {
        List<BookSearchModel> searchResults = await _searchRepository.SearchBook(userId, searchQuery);
        List<BookReadModel> booksFromMainDb = new();
        foreach (BookSearchModel book in searchResults)
        {
            BookModel? bookFromMainDb = await _bookRepository.GetBookById(book.id);
            if(bookFromMainDb is null) continue;
            
            await _bookRepository.LoadBookEntityReference(bookFromMainDb);
            booksFromMainDb.Add(BookReadModel.FromBookModel(bookFromMainDb));
        }
        
        return booksFromMainDb;
    }

    public async Task UpdateBook(int userId, int bookId, BookUpdateModel bookUpdate)
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

        UserModel? relatedUser = await _userRepository.GetUserById(userId);
        if(relatedUser is null)
        {
            Exception ex = new UserNotFoundException(userId);
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
        if(book.owner != relatedUser)
        {
            Exception ex = new NotOwnerBookException(book.title, relatedUser.username);
            _logger.Error(ex, ex.Message);
            throw ex;    
        }
        _logger.Information("Updating book ID[{0}]", book.id);
        
        if(bookUpdate.title is not null)
            book.title = bookUpdate.title;
        if(bookUpdate.author is not null)
            book.author = bookUpdate.author;
        if(bookUpdate.isbn is not null)
            book.isbn = bookUpdate.isbn;
        if(bookUpdate.publicationYear is not null)
            book.publicationYear = bookUpdate.publicationYear;
        if(bookUpdate.publisher is not null)
            book.publisher = bookUpdate.publisher;
        if(bookUpdate.edition is not null)
            book.edition = bookUpdate.edition;
        if(bookUpdate.pagesNumber is not null)
            book.pagesNumber = bookUpdate.pagesNumber;
        if(bookUpdate.genre is not null)
            book.genre = bookUpdate.genre;
        if(bookUpdate.format is not null)
            book.format = bookUpdate.format;
        if(bookUpdate.observation is not null)
            book.observation = bookUpdate.observation;
        if(bookUpdate.readed is not null)
            book.readed = bookUpdate.readed;
        if(bookUpdate.tags is not null)
            book.tags = bookUpdate.tags;
        
        await _bookRepository.Flush();
        await _searchRepository.UpdateSearchBook(bookId, BookSearchModel.FromBookModel(book));
        _logger.Information("Book ID[{0}] updated.", book.id);
    }
    
    //TODO: Return the ID of the deleted book
    public async Task DeleteBook(int userId, int bookId)
    {
        UserModel? relatedUser = await _userRepository.GetUserById(userId);
        if(relatedUser is null)
        {
            Exception ex = new UserNotFoundException(userId);
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
        if(book.owner != relatedUser)
        {
            Exception ex = new NotOwnerBookException(book.title, relatedUser.username);
            _logger.Error(ex, ex.Message);
            throw ex;
        }
        _logger.Information("Deleting book ID[{0}].", book.id);

        BookModel deletedBook = _bookRepository.DeleteBook(book);
        await _bookRepository.Flush();
        await _searchRepository.DeleteBookFromSearch(deletedBook.id);
        
        _metrics.DecreaseExsistingBooks();
        _logger.Information("Book ID[{0}] deleted.", book.id);
    }
}