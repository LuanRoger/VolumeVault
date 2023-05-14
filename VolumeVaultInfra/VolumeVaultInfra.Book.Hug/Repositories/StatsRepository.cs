using Microsoft.EntityFrameworkCore;
using VolumeVaultInfra.Book.Hug.Contexts;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Repositories;

public class StatsRepository : IStatsRepository
{
    private DatabaseContext context { get; }

    public StatsRepository(DatabaseContext context)
    {
        this.context = context;
    }
    
    public async Task<int> GetUserBooksCount(UserIdentifier user)
    {
        return await context.books
            .Where(book => book.owner == user)
            .CountAsync();
    }
}