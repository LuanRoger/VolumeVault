﻿using FluentValidation;
using FluentValidation.Results;
using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Context;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Services.Cache;

namespace VolumeVaultInfra.Controllers;

public class BookController : IBookController
{
    private DatabaseBaseContext _dbContext { get; }
    private BookCacheService _cache { get; }
    private IValidator<BookWriteModel> _bookWriteModelValidator { get; }
    private IValidator<BookUpdateModel> _bookUpdateModelValidator { get; }

    public BookController(DatabaseBaseContext dbContext,
        BookCacheService cache,
        IValidator<BookWriteModel> bookWriteModelValidator,
        IValidator<BookUpdateModel> bookUpdateModelValidator)
    {
        _dbContext = dbContext;
        _cache = cache;
        _bookWriteModelValidator = bookWriteModelValidator;
        _bookUpdateModelValidator = bookUpdateModelValidator;
    }
    
    public async Task RegisterNewBook(int userId, BookWriteModel book)
    {
        ValidationResult validationResult = await _bookWriteModelValidator.ValidateAsync(book);
        if(!validationResult.IsValid)
            throw new NotValidBookInformationException(validationResult
                .Errors
                .Select(errors => errors.ErrorMessage));
        
        UserModel? relatedUser = await _dbContext.users.FindAsync(userId);
        if(relatedUser is null)
            throw new UserNotFoundException(userId);
        
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
        _dbContext.books.Add(newBook);
        await _dbContext.SaveChangesAsync();
    }

    public async Task<List<BookReadModel>> GetAllUserReleatedBooks(int userId, int page, int limitPerPage,
        bool refresh)
    {
        UserModel? relatedUser = await _dbContext.users.FindAsync(userId);
        if(relatedUser is null)
            throw new UserNotFoundException(userId);
        
        List<BookReadModel>? cachedBooks = await _cache.TryGetUserCachedBook(relatedUser.id, page);
        if(cachedBooks is not null && !refresh)
            return cachedBooks;

        var userBooks = await _dbContext.books
            .Where(couponRecord => couponRecord.owner.id == relatedUser.id)
            .Skip(limitPerPage * page - limitPerPage)
            .Take(limitPerPage)
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
                owner = bookModel.owner,
            })
            .ToListAsync();
        
        await _cache.SetUserBooks(userBooks, userId, page);
        
        return userBooks;
    }

    public List<BookReadModel> SearchBookParameters(BookSearchModel bookSearchParameters)
    {
        throw new NotImplementedException();
    }

    public async Task UpdateBook(int userId, int bookId, BookUpdateModel bookUpdate)
    {
        ValidationResult validationResult = await _bookUpdateModelValidator.ValidateAsync(bookUpdate);
        if(!validationResult.IsValid)
            throw new NotValidBookInformationException(validationResult
                .Errors
                .Select(errors => errors.ErrorMessage));
        
        UserModel? relatedUser = await _dbContext.users.FindAsync(userId);
        if(relatedUser is null)
            throw new UserNotFoundException(userId);
        
        BookModel? book = await _dbContext.books.FindAsync(bookId);
        if(book is null)
            throw new BookNotFoundException(bookId);
        if(book.owner != relatedUser)
            throw new NotOwnerBookException(book.title, relatedUser.username);
        
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
        
        await _dbContext.SaveChangesAsync();
    }

    public async Task DeleteBook(int userId, int bookId)
    {
        UserModel? relatedUser = await _dbContext.users.FindAsync(userId);
        if(relatedUser is null)
            throw new UserNotFoundException(userId);
        
        BookModel? book = await _dbContext.books.FindAsync(bookId);
        if(book is null)
            throw new BookNotFoundException(bookId);
        if(book.owner != relatedUser)
            throw new NotOwnerBookException(book.title, relatedUser.username);

        _dbContext.books.Remove(book);
        await _dbContext.SaveChangesAsync();
    }
}