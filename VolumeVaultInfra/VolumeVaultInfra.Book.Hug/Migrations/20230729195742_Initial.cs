using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace VolumeVaultInfra.Book.Hug.Migrations
{
    /// <inheritdoc />
    public partial class Initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Badge",
                columns: table => new
                {
                    ID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    BadgeCode = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Badge", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "Genres",
                columns: table => new
                {
                    ID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Genre = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Genres", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "Tags",
                columns: table => new
                {
                    ID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Tag = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tags", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "UserIdentifier",
                columns: table => new
                {
                    ID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserIdentifier = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserIdentifier", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "BadgeUser",
                columns: table => new
                {
                    ID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Badge = table.Column<int>(type: "integer", nullable: false),
                    User = table.Column<int>(type: "integer", nullable: false),
                    ClaimedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BadgeUser", x => x.ID);
                    table.ForeignKey(
                        name: "FK_BadgeUser_Badge_Badge",
                        column: x => x.Badge,
                        principalTable: "Badge",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BadgeUser_UserIdentifier_User",
                        column: x => x.User,
                        principalTable: "UserIdentifier",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Books",
                columns: table => new
                {
                    ID = table.Column<Guid>(type: "uuid", nullable: false),
                    Title = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Author = table.Column<string>(type: "text", nullable: false),
                    ISBN = table.Column<string>(type: "character varying(17)", maxLength: 17, nullable: false),
                    PublicationYear = table.Column<int>(type: "integer", nullable: true),
                    Publisher = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    Edition = table.Column<int>(type: "integer", nullable: true),
                    PagesNumber = table.Column<int>(type: "integer", nullable: true),
                    Format = table.Column<int>(type: "integer", nullable: true),
                    Obsevation = table.Column<string>(type: "text", nullable: true),
                    Synopsis = table.Column<string>(type: "character varying(300)", maxLength: 300, nullable: true),
                    CoverLink = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    BuyLink = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    Readed = table.Column<int>(type: "integer", nullable: true),
                    ReadStartDay = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    ReadEndDay = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    LastModification = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    ownerid = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Books", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Books_UserIdentifier_ownerid",
                        column: x => x.ownerid,
                        principalTable: "UserIdentifier",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "EmailUserIdentifier",
                columns: table => new
                {
                    ID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Email = table.Column<string>(type: "text", nullable: false),
                    UserIdentifier = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_EmailUserIdentifier", x => x.ID);
                    table.ForeignKey(
                        name: "FK_EmailUserIdentifier_UserIdentifier_UserIdentifier",
                        column: x => x.UserIdentifier,
                        principalTable: "UserIdentifier",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "BookGenre",
                columns: table => new
                {
                    ID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Book = table.Column<Guid>(type: "uuid", nullable: false),
                    Genre = table.Column<int>(type: "integer", nullable: false),
                    UserIdentifier = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BookGenre", x => x.ID);
                    table.ForeignKey(
                        name: "FK_BookGenre_Books_Book",
                        column: x => x.Book,
                        principalTable: "Books",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BookGenre_Genres_Genre",
                        column: x => x.Genre,
                        principalTable: "Genres",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BookGenre_UserIdentifier_UserIdentifier",
                        column: x => x.UserIdentifier,
                        principalTable: "UserIdentifier",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BookTag",
                columns: table => new
                {
                    ID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    BookId = table.Column<Guid>(type: "uuid", nullable: false),
                    TagId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BookTag", x => x.ID);
                    table.ForeignKey(
                        name: "FK_BookTag_Books_BookId",
                        column: x => x.BookId,
                        principalTable: "Books",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BookTag_Tags_TagId",
                        column: x => x.TagId,
                        principalTable: "Tags",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BadgeEmailUser",
                columns: table => new
                {
                    ID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    EmailIdentifier = table.Column<int>(type: "integer", nullable: false),
                    Badge = table.Column<int>(type: "integer", nullable: false),
                    AttachDateTime = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BadgeEmailUser", x => x.ID);
                    table.ForeignKey(
                        name: "FK_BadgeEmailUser_Badge_Badge",
                        column: x => x.Badge,
                        principalTable: "Badge",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BadgeEmailUser_EmailUserIdentifier_EmailIdentifier",
                        column: x => x.EmailIdentifier,
                        principalTable: "EmailUserIdentifier",
                        principalColumn: "ID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Badge",
                columns: new[] { "ID", "BadgeCode" },
                values: new object[,]
                {
                    { 1, 0 },
                    { 2, 1 },
                    { 3, 2 },
                    { 4, 3 },
                    { 5, 4 },
                    { 6, 5 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_BadgeEmailUser_Badge",
                table: "BadgeEmailUser",
                column: "Badge");

            migrationBuilder.CreateIndex(
                name: "IX_BadgeEmailUser_EmailIdentifier",
                table: "BadgeEmailUser",
                column: "EmailIdentifier");

            migrationBuilder.CreateIndex(
                name: "IX_BadgeUser_Badge",
                table: "BadgeUser",
                column: "Badge");

            migrationBuilder.CreateIndex(
                name: "IX_BadgeUser_User",
                table: "BadgeUser",
                column: "User");

            migrationBuilder.CreateIndex(
                name: "IX_BookGenre_Book",
                table: "BookGenre",
                column: "Book");

            migrationBuilder.CreateIndex(
                name: "IX_BookGenre_Genre",
                table: "BookGenre",
                column: "Genre");

            migrationBuilder.CreateIndex(
                name: "IX_BookGenre_UserIdentifier",
                table: "BookGenre",
                column: "UserIdentifier");

            migrationBuilder.CreateIndex(
                name: "IX_Books_ownerid",
                table: "Books",
                column: "ownerid");

            migrationBuilder.CreateIndex(
                name: "IX_BookTag_BookId",
                table: "BookTag",
                column: "BookId");

            migrationBuilder.CreateIndex(
                name: "IX_BookTag_TagId",
                table: "BookTag",
                column: "TagId");

            migrationBuilder.CreateIndex(
                name: "IX_EmailUserIdentifier_Email",
                table: "EmailUserIdentifier",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_EmailUserIdentifier_UserIdentifier",
                table: "EmailUserIdentifier",
                column: "UserIdentifier");

            migrationBuilder.CreateIndex(
                name: "IX_Genres_Genre",
                table: "Genres",
                column: "Genre",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tags_Tag",
                table: "Tags",
                column: "Tag",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserIdentifier_UserIdentifier",
                table: "UserIdentifier",
                column: "UserIdentifier",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BadgeEmailUser");

            migrationBuilder.DropTable(
                name: "BadgeUser");

            migrationBuilder.DropTable(
                name: "BookGenre");

            migrationBuilder.DropTable(
                name: "BookTag");

            migrationBuilder.DropTable(
                name: "EmailUserIdentifier");

            migrationBuilder.DropTable(
                name: "Badge");

            migrationBuilder.DropTable(
                name: "Genres");

            migrationBuilder.DropTable(
                name: "Books");

            migrationBuilder.DropTable(
                name: "Tags");

            migrationBuilder.DropTable(
                name: "UserIdentifier");
        }
    }
}
