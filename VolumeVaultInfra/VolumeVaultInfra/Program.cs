using System.Globalization;
using System.Text;
using FluentValidation;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.IdentityModel.Tokens;
using Serilog;
using VolumeVaultInfra.Context;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Services.Cache;
using VolumeVaultInfra.Services.Jwt;
using VolumeVaultInfra.Utils;
using VolumeVaultInfra.Validators;
using ILogger = Serilog.ILogger;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

CultureInfo.CurrentUICulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.CurrentCulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.DefaultThreadCurrentCulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.DefaultThreadCurrentUICulture = CultureInfo.GetCultureInfo("en-US");

ILogger logger = new LoggerConfiguration().WriteTo
    .Console()
    .CreateLogger();
builder.Logging.ClearProviders();
builder.Logging.AddSerilog(logger);
builder.Host.UseSerilog(logger);

#region General Services
builder.Services.AddDbContext<DatabaseBaseContext, DatabaseContext>(optionsBuilder =>
{
    string connString = builder.Configuration
        .GetConnectionString("PostgresConnectionString")!;
    optionsBuilder.UseNpgsql(connString);
});
builder.Services.AddStackExchangeRedisCache(options =>
{
    options.Configuration = builder.Configuration.GetConnectionString("RedisConfigurationString");
});
builder.Services.AddScoped<BookCacheService>(provider =>
{
    DistributedCacheEntryOptions cacheOptions = new()
    {
        AbsoluteExpirationRelativeToNow = TimeSpan.FromSeconds(60),
        SlidingExpiration = TimeSpan.FromSeconds(20)
    };
    return new(provider.GetRequiredService<IDistributedCache>(), cacheOptions);
});
builder.Services.AddSingleton<JwtService>(_ =>
{
    string? jwtSymetricKey = EnvironmentsVariables.GetSymetricKey();
    if(jwtSymetricKey is null)
        throw new(EnvVariableConsts.JWT_SYMETRIC_KEY);
    
    return new(jwtSymetricKey);
});
builder.Services.AddScoped<IUserController, UserController>();
builder.Services.AddScoped<IBookController, BookController>();
#endregion

#region Validation Services
builder.Services.AddScoped<IValidator<UserWriteModel>, UserWriteModelValidator>();
builder.Services.AddScoped<IValidator<BookWriteModel>, BookWriteModelValidator>();
builder.Services.AddScoped<IValidator<BookUpdateModel>, BookUpdateModelValidator>();
#endregion

builder.Services.AddAuthentication(options =>
{
    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
    .AddJwtBearer(options =>
    {
        string? jwtSymetricKey = EnvironmentsVariables.GetSymetricKey();
        if(jwtSymetricKey is null)
            throw new(EnvVariableConsts.JWT_SYMETRIC_KEY);
        
        options.TokenValidationParameters = new()
        {
            ValidateIssuer = true,
            ValidateLifetime = true,
            ValidateAudience = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSymetricKey)),
            ValidAlgorithms = new [] { SecurityAlgorithms.HmacSha256Signature },
            ValidAudience = JwtServiceConsts.jwtAudience,
            ValidIssuer = JwtServiceConsts.jwtIssuer
        };
    });
builder.Services.AddAuthorization();

WebApplication app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

using (IServiceScope scope = app.Services.CreateScope())
{
    DatabaseContext? context = scope.ServiceProvider.GetService<DatabaseContext>();
    context?.Database.EnsureCreated();
}

app.UseAuthentication();
app.UseAuthorization();

#region UserEndpoint
app.MapPost("auth/signin", 
    async ([FromServices] IUserController userController,
    [FromBody] UserWriteModel userWrite) =>
{
    string jwt;
    try
    {
        jwt = await userController.SigninUser(userWrite);
    }
    catch(UserAlreadyExistException e)
    {
        return Results.Conflict(e.Message);
    }
    catch(NotValidUserWriteException e)
    {
        return Results.BadRequest(e.Message);
    }
    
    return Results.Ok(jwt);
});
app.MapGet("auth/login", 
    async ([FromServices] IUserController userController,
    [FromBody] UserLoginRequestModel loginRequest) =>
{
    string jwt;
    try
    {
        jwt = await userController.LoginUser(loginRequest);
    }
    catch(UsernameIsNotRegisteredException e)
    {
        return Results.NotFound(e.Message);
    }
    catch(InvalidUserCredentialsException)
    {
        return Results.Unauthorized();
    }
    
    return Results.Ok(jwt);
});
#endregion

#region BooksEndpoint
app.MapGet("books", 
    async (HttpContext context, 
        [FromQuery] int page, 
        [FromQuery] int? limitPerPage,
        [FromQuery] bool? refresh,
        [FromServices] IBookController bookController) =>
{
   int idClaim = int.Parse(context.User.Claims
       .First(claim => claim.Type == "ID").Value);
   
   List<BookReadModel> userBooks;
   try
   {
       userBooks = await bookController.GetAllUserReleatedBooks(idClaim, page, limitPerPage ?? 10, refresh ?? false);
   }
   catch(UserNotFoundException e)
   {
       return Results.BadRequest(e.Message);
   }

   return Results.Ok(userBooks);
}).RequireAuthorization(policyBuilder =>
    {
        policyBuilder.RequireClaim("ID");
    });
app.MapPost("books", 
    async (HttpContext context, 
        [FromBody] BookWriteModel bookWriteInfo, 
        [FromServices] IBookController bookController) =>
    {
        int idClaim = int.Parse(context.User.Claims
            .First(claim => claim.Type == "ID").Value);
    
        try
        {
            await bookController.RegisterNewBook(idClaim, bookWriteInfo);
        }
        catch(Exception e) when (e is UserNotFoundException or NotValidBookInformationException)
        {
            return Results.BadRequest(e.Message);
        }
     
        return Results.Ok();
    }).RequireAuthorization(policyBuilder =>
{
    policyBuilder.RequireClaim("ID");
});
app.MapDelete("books/{id:int}", 
    async (HttpContext context, 
        int id, 
        [FromServices] IBookController bookController) =>
{
    int idClaim = int.Parse(context.User.Claims
        .First(claim => claim.Type == "ID").Value);
    
    try
    {
       await bookController.DeleteBook(idClaim, id);
    }
    catch(Exception e) when (e is UserNotFoundException or BookNotFoundException)
    {
        return Results.BadRequest(e.Message);
    }
    catch(NotOwnerBookException)
    {
        return Results.Unauthorized();
    }
    
    return Results.Ok();
}).RequireAuthorization(policyBuilder =>
    {
        policyBuilder.RequireClaim("ID");
    });
app.MapPut("books/{id:int}", 
    async (HttpContext context,
        int id,
        [FromServices] IBookController bookController,
        [FromBody] BookUpdateModel bookUpdate) => 
{
    int idClaim = int.Parse(context.User.Claims
        .First(claim => claim.Type == "ID").Value);
        
    try
    {
        await bookController.UpdateBook(idClaim, id, bookUpdate);
    }
    catch(Exception e) when (e is UserNotFoundException or 
                                 BookNotFoundException or 
                                 NotValidBookInformationException)
    {
        return Results.BadRequest(e.Message);
    }
        
    return Results.Ok();
}).RequireAuthorization(policyBuilder =>
    {
        policyBuilder.RequireClaim("ID");
    });
#endregion

app.Run();