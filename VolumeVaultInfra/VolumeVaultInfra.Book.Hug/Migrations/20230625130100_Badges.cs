using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace VolumeVaultInfra.Book.Hug.Migrations
{
    /// <inheritdoc />
    public partial class Badges : Migration
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
                name: "BadgeUser",
                columns: table => new
                {
                    ID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    BadgeCode = table.Column<int>(type: "integer", nullable: false),
                    User = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BadgeUser", x => x.ID);
                    table.ForeignKey(
                        name: "FK_BadgeUser_Badge_BadgeCode",
                        column: x => x.BadgeCode,
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

            migrationBuilder.CreateIndex(
                name: "IX_BadgeUser_BadgeCode",
                table: "BadgeUser",
                column: "BadgeCode");

            migrationBuilder.CreateIndex(
                name: "IX_BadgeUser_User",
                table: "BadgeUser",
                column: "User");

            migrationBuilder.CreateIndex(
                name: "IX_EmailUserIdentifier_UserIdentifier",
                table: "EmailUserIdentifier",
                column: "UserIdentifier");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BadgeUser");

            migrationBuilder.DropTable(
                name: "EmailUserIdentifier");

            migrationBuilder.DropTable(
                name: "Badge");
        }
    }
}
