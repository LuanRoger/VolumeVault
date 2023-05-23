namespace VolumeVaultInfra.Book.Search.Models;

public record BookSearchRequest(string query, int limitPerSection, string userId);