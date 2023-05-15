namespace VolumeVaultInfra.Book.Search.Validators;

public static class ValidationRegex
{
    public const string ISBN_REGEX = @"/^(?=(?:\D*\d){10}(?:(?:\D*\d){3})?$)[\d-]+$/gm";
}