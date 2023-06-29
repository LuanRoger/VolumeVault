using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace VolumeVaultInfra.Book.Hug.Migrations
{
    /// <inheritdoc />
    public partial class BadgeArchive : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "ClaimedAt",
                table: "BadgeUser",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.CreateTable(
                name: "BadgeEmailUser",
                columns: table => new
                {
                    ID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    EmailIdentifier = table.Column<int>(type: "integer", nullable: false),
                    Badge = table.Column<int>(type: "integer", nullable: false)
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

            migrationBuilder.CreateIndex(
                name: "IX_EmailUserIdentifier_Email",
                table: "EmailUserIdentifier",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_BadgeEmailUser_Badge",
                table: "BadgeEmailUser",
                column: "Badge");

            migrationBuilder.CreateIndex(
                name: "IX_BadgeEmailUser_EmailIdentifier",
                table: "BadgeEmailUser",
                column: "EmailIdentifier");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BadgeEmailUser");

            migrationBuilder.DropIndex(
                name: "IX_EmailUserIdentifier_Email",
                table: "EmailUserIdentifier");

            migrationBuilder.DropColumn(
                name: "ClaimedAt",
                table: "BadgeUser");
        }
    }
}
