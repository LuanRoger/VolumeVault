namespace VolumeVaultInfra.Services.Metrics;

public interface IBookControllerMetrics
{
    void IncreaseRegisteredBooks();
    void IncreaseExistingBooks();
    void DecreaseExsistingBooks();
    void ObserverBookPageNumber(double? pageNumb);
}