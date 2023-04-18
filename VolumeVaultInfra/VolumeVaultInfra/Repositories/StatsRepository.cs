using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Context;

namespace VolumeVaultInfra.Repositories;

public class StatsRepository : IStatsRepository
{
    private DatabaseContext context { get; }

    public StatsRepository(DatabaseContext context)
    {
        this.context = context;
    }
    
    public async Task<int> GetUserBooksCount(int userId)
    {
        return await context.books.Where(book => book.owner.id == userId)
            .CountAsync();
    }
}