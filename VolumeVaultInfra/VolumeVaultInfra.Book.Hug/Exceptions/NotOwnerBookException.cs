﻿namespace VolumeVaultInfra.Book.Hug.Exceptions;

public class NotOwnerBookException : Exception
{
    private const string MESSAGE = "The book {0} is not owned by {1}";

    public NotOwnerBookException(string bookName, string userId) : 
        base(string.Format(MESSAGE, bookName, userId)) { }
}