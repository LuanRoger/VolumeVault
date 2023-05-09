FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["VolumeVaultInfra.Book.Hug/VolumeVaultInfra.Book.Hug.csproj", "VolumeVaultInfra.Book.Hug/"]
RUN dotnet restore "VolumeVaultInfra.Book.Hug/VolumeVaultInfra.Book.Hug.csproj"
COPY . .
WORKDIR "/src/VolumeVaultInfra.Book.Hug"
RUN dotnet build "VolumeVaultInfra.Book.Hug.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "VolumeVaultInfra.Book.Hug.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "VolumeVaultInfra.Book.Hug.dll"]
