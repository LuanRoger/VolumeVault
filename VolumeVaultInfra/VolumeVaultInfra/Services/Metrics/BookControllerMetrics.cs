using Prometheus;

namespace VolumeVaultInfra.Services.Metrics;

public class BookControllerMetrics : IBookControllerMetrics
{
    private static Counter registeredBooks => Prometheus.Metrics
        .CreateCounter("vvinfra_books_registered_total", "Number of registered books.");
    private static Gauge existingBooks => Prometheus.Metrics
        .CreateGauge("vvinfra_books_existing_total", "Number of books currently registered.");
    private static Histogram averagePagenumber => Prometheus.Metrics
        .CreateHistogram("vvinfra_book_pages_average", "Summary of page number of registered books");

    public void IncreaseRegisteredBooks() => registeredBooks.Inc();
    public void IncreaseExistingBooks() =>existingBooks.Inc();

    public void DecreaseExsistingBooks() => existingBooks.Dec();

    public void ObserverBookPageNumber(double? pageNumb)
    {
        if(pageNumb is null) return;
        
        averagePagenumber.Observe((double)pageNumb);
    }
}