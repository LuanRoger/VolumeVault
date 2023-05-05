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
    
    public async Task<int> GetUserBooksCount(string userId)
    {
        return await context.books
            .Where(book => book.owner == userId)
            .CountAsync();
    }
}