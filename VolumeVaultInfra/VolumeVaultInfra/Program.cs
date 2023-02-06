using System.Globalization;
using System.Text;
using FluentValidation;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Serilog;
using VolumeVaultInfra.Context;
using VolumeVaultInfra.Controllers;
using VolumeVaultInfra.Exceptions;
using VolumeVaultInfra.Models.Book;
using VolumeVaultInfra.Models.User;
using VolumeVaultInfra.Repositories;
using VolumeVaultInfra.Services.Jwt;
using VolumeVaultInfra.Utils;
using VolumeVaultInfra.Validators;
using ILogger = Serilog.ILogger;
using Prometheus;
using VolumeVaultInfra.Services;
using VolumeVaultInfra.Services.Metrics;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

CultureInfo.CurrentUICulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.CurrentCulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.DefaultThreadCurrentCulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.DefaultThreadCurrentUICulture = CultureInfo.GetCultureInfo("en-US");

ILogger logger = new LoggerConfiguration()
    .Enrich.WithMachineName()
    .WriteTo.Console()
    .Enrich.WithProperty("Environment", EnvVariableConsts.ASPNETCORE_ENVIRONMENT)
    .ReadFrom.Configuration(builder.Configuration)
    .CreateLogger();
builder.Logging.ClearProviders();
builder.Logging.AddSerilog(logger);
builder.Host.UseSerilog(logger);

#region General Services
builder.Services.AddHealthChecks()
    .AddCheck<HealthCheckService>(nameof(HealthCheckService))
    .ForwardToPrometheus();
builder.Services.AddDbContext<DatabaseBaseContext, DatabaseContext>(optionsBuilder =>
{
    if(builder.Environment.IsDevelopment())
    {
        optionsBuilder.UseNpgsql(builder.Configuration
            .GetConnectionString("PostgresConnectionString")!);
        return;
    }
    
    string? connStringHolder = builder.Configuration
        .GetConnectionString("PostgresConnectionString");
    if(string.IsNullOrEmpty(connStringHolder))
        throw new RequiredConfigurationException("PostgresConnectionString");
    
    string? postgresUser = EnvironmentsVariables.GetVvPostgresUser();
    string? postgresPassword = EnvironmentsVariables.GetVvPosgresPassword();
    string? postgresHost = EnvironmentsVariables.GetPostgresHost();
    string? postgresPort = EnvironmentsVariables.GetPostgresPort();
    string? dbName = EnvironmentsVariables.GetDefaultPostgresDbName();

    if(string.IsNullOrEmpty(postgresUser))
        throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.VV_POSTGRES_USER);
    if(string.IsNullOrEmpty(postgresPassword))
        throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.VV_POSTGRES_PASSWORD);
    if(string.IsNullOrEmpty(postgresHost))
        throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.POSTGRES_HOST);
    if(string.IsNullOrEmpty(postgresPort))
        throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.POSTGRES_PORT);
    if(string.IsNullOrEmpty(dbName))
        throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.DEFAULT_POSTGRES_DB_NAME);
    
    string connString = string.Format(connStringHolder, postgresUser, postgresPassword,
        postgresHost, postgresPort, dbName);
    optionsBuilder.UseNpgsql(connString);
});
builder.Services.AddSingleton<JwtService>(_ =>
{
    string? jwtSymetricKey = EnvironmentsVariables.GetSymmetricKey();
    if(jwtSymetricKey is null)
        throw new(EnvVariableConsts.JWT_SYMMETRIC_KEY);
    
    return new(jwtSymetricKey);
});
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<IBookRepository, BookRepository>();
builder.Services.AddScoped<IUserController, UserController>();
builder.Services.AddScoped<IBookController, BookController>();
builder.Services.AddScoped<IBookControllerMetrics, BookControllerMetrics>();
builder.Services.AddScoped<IUserControllerMetrics, UserControllerMetrics>();
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
        string? jwtSymmetricKey = EnvironmentsVariables.GetSymmetricKey();
        if(string.IsNullOrEmpty(jwtSymmetricKey))
            throw new EnvironmentVariableNotProvidedException(EnvVariableConsts.JWT_SYMMETRIC_KEY);
        
        options.TokenValidationParameters = new()
        {
            ValidateIssuer = true,
            ValidateLifetime = true,
            ValidateAudience = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSymmetricKey)),
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

app.UseStaticFiles();
app.UseRouting();

app.UseHttpMetrics();

app.UseAuthentication();
app.UseAuthorization();

#region SystemEndpoints
#pragma warning disable ASP0014
app.UseEndpoints(endpointOptions => endpointOptions.MapMetrics());
#pragma warning restore ASP0014
#endregion

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