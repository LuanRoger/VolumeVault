<img src="https://github.com/LuanRoger/VolumeVault/blob/main/images/icon.png" align="left" height="110">
<h1>Volume Vault</h1>
<h3>Keep your books informations safe and sound.</h3>

[![VolumeVaultInfra CI](https://github.com/LuanRoger/VolumeVault/actions/workflows/VolumeVaultInfra-CI.yml/badge.svg?branch=main)](https://github.com/LuanRoger/VolumeVault/actions/workflows/VolumeVaultInfra-CI.yml)
[![codecov](https://codecov.io/gh/LuanRoger/VolumeVault/branch/main/graph/badge.svg?token=YYL3LKQ2VB)](https://codecov.io/gh/LuanRoger/VolumeVault)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

## Features
- 📖 Save your books informations.
- 🔒 Authenticate with different users.
- 📷 Add cover image for books.
- 🖌️ Themes: Dark and light mode.
- 💬 Multi-language support.
- 🪢 Filter result.
- 🏅 Badges for users.

## Stack overview
- 🖥️ UI build with [Flutter](https://flutter.dev/) and [Material Desing 3](https://m3.material.io)
- 📡 Own designed REST API build with [ASP.NET](https://dotnet.microsoft.com/en-us/apps/aspnet).
- 🔍 Fast search with [Meilisearch](https://www.meilisearch.com).
- 🐋 [Docker](https://www.docker.com) and Docker Compose support.
- 🔨 Multi environment build (development, sttaging, production).
- 🔥 Integration with Firebase Admim SDK.
- 🛣️ API versioning.
- 📤 Output cache.

## Other techs, tools and libs
- [Serilog](https://serilog.net).
- [FluentValidation](https://docs.fluentvalidation.net).
- [AutoMapper](https://automapper.org).
- Entity Framework.
- Postgres.

## Prerequisite
- Flutter
- Docker
- Docker Compose
- Firebase service

# Front-end client
The front-end was build with Flutter and have a responsive interface using Responsive Framework package, was created interface for Mobile (480), Tablet (700) and Desktop (1000) screen sizes.

[![Flutter Responsive](https://img.shields.io/badge/flutter-responsive-brightgreen.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework)

# API Specifications (VolumeVaulInfra API)
The API manage books and badges, it integrates with Firebase to check the users, was create with ASP.NET using Entity Framework to CRUD into a Postgres database, while all operations is logged by Serilog.

The API have a versioning system especified on requests header and an internal cache system to improve the performance.
# Endpoints
Cheke out the [Postman](https://www.postman.com) collection to see all endpoints and examples:

[![Postman](https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white)](https://github.com/LuanRoger/VolumeVault/tree/main/postman)

## Hug service
### `/book`
- GET `/`
  - `?limitPerPage=10`
  - `?sort=0`
  - `?ascending=true`
  - `?bookFormat=1`
  - `?page=1`
  - `?userId=0`
- POST `/`
  - > Has body
  - `?userId=0`
- PUT `/{bookID:int}`
  - `?userId=0`
- DELETE `/{bookID:int}`
### `/stats`
- GET `/`
  - `?userId=0`
### `/badge`
- GET `/`
  - `?userId=0`
- POST `/`
  - `?userId=0`
- DELETE `/{badgeID:int}`
  - `?userId=0`
- GET `/archive`
  - `?email=test@test.com`
- PUT `/archive`
  - > Has body
- POST `/archive`
  - > Has body
- DELETE `/archive`
  - `?email=test@test.com`
  - `?badgeCode=0`
### `/auth`
- GET `/email/{userEmail}`
- GET `/id/{firebaseUserUid}`
- GET `/search`
  - `?query={string}`

## Search service
### `/search`
- GET `/`
  - `?userId=0`
  - `?query={string}`
  - `?limitPerSection=10`

## Setup
To setup the project (development/production environments) [click here](https://github.com/LuanRoger/VolumeVault/blob/main/SETUP.md).

# Screenshots
|                                                                            |
|----------------------------------------------------------------------------|
| ![https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page01.png](https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page01.png) |
| ![https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page03.png](https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page03.png) |
| ![https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page02.png](https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page02.png) |
| ![https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page04.png](https://github.com/LuanRoger/VolumeVault/blob/main/images/home_page04.png) |

## Deploy it
[![DigitalOcean Referral Badge](https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%203.svg)](https://www.digitalocean.com/?refcode=dddd7d890760&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)
