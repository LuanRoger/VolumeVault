# Setup (development environment)
## Front-end
Before execute the `flutter run` command you need to create a copy of [`.env.example`](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/.env.example) as `.env`, change the variables correctly and generate the `.g.dart` files used by the project with build_runner:

```powershell
cp .\.env.example .env
dart run build_runner build
```
To run in release mode:
```powershell
flutter run --release
```
## Back-end (development)
The API usese the Firebase Admim SDK, so it's nescessary to setup properly, for this, follow the [official guide](https://firebase.google.com/docs/admin/setup?hl=pt-br#initialize_the_sdk_in_non-google_environments) (the API uses the JSON private key). Paste the JSON file on the root directory of Hug service (`./VolumeVaultInfra/VolumeVaultInfra.Book.Hug`).

Meilisearch and Postgres are mandatory to the API work, you can follow the steps above to get the things work.

If you will run the API in development mode you need to change/check some parameters in [appsettings.Development.json](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/VolumeVaultInfra/appsettings.Development.json) to avoid connection issues with the other services (Meilisearch and Postgres).
Also you will have to change the [launchSettings.json](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/VolumeVaultInfra/Properties/launchSettings.json).

There no docker-compose file for development environment, do you need to start the services manually.

To start Postgres you can use:
```powershell
docker run --name postgres -p 5432:5432 -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=admin -d postgres
```

To start Meilisearch in development mode you can use:
```powershell
docker run --name meilisearch -p 7700:7700 -e MEILI_ENV="development" -d getmeili/meilisearch
```
Check the [Meilisearch's official documentation](https://docs.meilisearch.com/learn/cookbooks/docker.html#download-meilisearch-with-docker) for more advanced Docker setups.

Don't forget to change the [appsettings.Development.json](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/VolumeVaultInfra/appsettings.Development.json) file.

## Setup (production mode)
The API comes ready with a docker-compose file that runs in production mode. 
You can check the API's [Dockerfile here](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/VolumeVaultInfra/Dockerfile).

Before run the docker-compose create a copy of [`.env.example`](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/.env.example) as `.env` and made the properly changes file, is not secure to run in production mode with the default values.

After change the [.env](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/.env) file run the Docker Compose command in [VolumeVaultInfra directory](https://github.com/LuanRoger/VolumeVault/tree/main/VolumeVaultInfra) to start:
```powershell
docker-compose up -d
```