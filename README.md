<img src="https://github.com/LuanRoger/VolumeVault/blob/main/images/icon.png" align="left" height="110">
<h1>Volume Vault</h1>
<h3>Keep your books informations safe and sound.</h3>

[![VolumeVaultInfra CI](https://github.com/LuanRoger/VolumeVault/actions/workflows/VolumeVaultInfra-CI.yml/badge.svg?branch=main)](https://github.com/LuanRoger/VolumeVault/actions/workflows/VolumeVaultInfra-CI.yml)

## Features
- 📖 Save your books informations.
- 🔒 Authenticate with different users.
- 📷 Add cover image for books.
- 🖌️ Themes: Dark and light mode.
- 💬 Multi-language support.

## Stack overview
- 🖥️ UI build with [Flutter](https://flutter.dev/) and [Material Desing 3](https://m3.material.io)
- 📡 Own designed REST API build with [ASP.NET](https://dotnet.microsoft.com/en-us/apps/aspnet).
- 👀 Observability system with [Prometheus](https://prometheus.io) and [Grafana](https://grafana.com), exporting custom metrics from API.
- 🔍 Really fast search with [Meilisearch](https://www.meilisearch.com).
- 🧱 Very concise micro-service architecture.
- 🐋 Docker and Docker Compose support.

## Other techs, tools and libs
- JWT
- Argon2
- EntityFramework
- Postgres

## Prerequisite
- Flutter
- Docker
- Docker Compose

# Front-end client
The front-end was build with Flutter and have a responsive interface using Responsive Framework package, was created interface for Mobile (480), Tablet (700) and Desktop (1000) screen sizes.

[![Flutter Responsive](https://img.shields.io/badge/flutter-responsive-brightgreen.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework)

## Start front-end
Before execute the `flutter run` command you need to generate the `.g.dart` files used by the project with build_runner:
```powershell
flutter pub run build_runner build
```
To run in release mode:
```powershell
flutter run --release
```

# API Specifications (VolumeVaulInfra API)
The API was created with ASP.NET and supports Swagger UI for documentation available on [http://localhost:5081](http://localhost:5081).

### Endpoints
[![Postman](https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white)](https://github.com/LuanRoger/VolumeVault/tree/main/postman)

- POST `/auth/signin`
- POST `/auth/login`
- GET `/auth`
- `/book`
  - POST `/book`
    - `?limitPerPage={int}`
    - `?page=1`
  - DEL `book/{bookID:int}`
  - PUT `book/1`
- GET `book/1`
- GET `/search`
  - `?query={string}`
- GET `/utils/ping`
- GET `utils/check_auth_token`
- GET `/utils/check_auth_token`
- GET `book/genres`

## Prometheus custom metrics
The API export some custom metrics to the `/metrics` endpoints:

### Book metrics
- `vvinfra_books_registered_total`: Number of registered books.
- `vvinfra_books_existing_total`: Number of books currently registered.
- `vvinfra_book_pages_average`: Summary of page number of registered books.

### User metrics
- `vvinfra_registered_users_total`: Number of registered users.
- `vvinfra_logins_request_total`: Number of login requests.

Meilisearch and Postgres are mandatory to the API work, you can follow the steps above to get the things work.

## Setup (development environment)
If you will run the API in development mode you need to change/check some parameters in [appsettings.Development.json](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/VolumeVaultInfra/appsettings.Development.json) to avoid connection issues with the services (Meilisearch and Postgres).
Also you will have to change the [launchSettings.json](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/VolumeVaultInfra/Properties/launchSettings.json)
There no docker-compose file for development environment, do you need to start the services manually.

To start Postgres you can use:
```powershell
docker run --name postgres -p 5432:5432 -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=admin -d postgres
```

And to start Meilisearch in development mode you can use:
```powershell
docker run --name meilisearch -p 7700:7700 -e MEILI_ENV="development" -d getmeili/meilisearch
```
Check the [Meilisearch's official documentation](https://docs.meilisearch.com/learn/cookbooks/docker.html#download-meilisearch-with-docker) for more advanced Docker setups.

Don't forget to change the [appsettings.Development.json](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/VolumeVaultInfra/appsettings.Development.json) file.

The API also supports Prometheus and Grafana, but both are not mandatory to the API work. If you don't want to use those services in your development environment, stop here and happy coding.

## Prometheus setup (development mode)
You can use Docker to up the Prometheus as fallow:
```powershell
docker run --name prometheus -p 9090:9090 -v ./prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
```
Change the file [prometheus.yml](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/prometheus.yml) as need and map it to `/etc/prometheus/prometheus.yml` with `-v`.

**This file are prepared to be mapped to the Prometheus container created by the Docker Compose in production, so is recomended to create a copy of the file.**

The API export the metrics at [http://localhost:5081/metrics](http://localhost:5081/metrics).

## Grafana setup (development mode)
It's recommend to use the Grafana Open Source image:
Grafana Open Source: `grafana/grafana-oss`
You can start Grafana with:
```powershell
docker run -d -p 3000:3000 grafana/grafana-oss
```
Here I will not show how to setup Prometheus in Grafana, to see how to do that go to the [Grafana's official documentation](https://grafana.com/docs/grafana/latest/getting-started/get-started-grafana-prometheus)


## Setup (production mode)
The API comes ready with a docker-compose file that runs in production mode. 
You can check the API's [Dockerfile here](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/VolumeVaultInfra/Dockerfile).

Before run the docker-compose file made the changes in the [.env](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/.env) file, is not secure to run in production mode with the default values.

After change the [.env](https://github.com/LuanRoger/VolumeVault/blob/main/VolumeVaultInfra/.env) file run the Docker Compose command in [VolumeVaultInfra directory](https://github.com/LuanRoger/VolumeVault/tree/main/VolumeVaultInfra) to start:
```powershell
docker-compose up -d
```

## Deploy it
[![DigitalOcean Referral Badge](https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%203.svg)](https://www.digitalocean.com/?refcode=dddd7d890760&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

## Screenshots
|                                                                            |
|----------------------------------------------------------------------------|
| ![https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page01.png](https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page01.png) |
| ![https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page03.png](https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page03.png) |
| ![https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page02.png](https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page02.png) |
| ![https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page04.png](https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page04.png) |
