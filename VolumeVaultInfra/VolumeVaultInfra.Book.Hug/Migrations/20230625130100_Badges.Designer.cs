﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;
using VolumeVaultInfra.Book.Hug.Contexts;

#nullable disable

namespace VolumeVaultInfra.Book.Hug.Migrations
{
    [DbContext(typeof(DatabaseContext))]
    [Migration("20230625130100_Badges")]
    partial class Badges
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.5")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.BadgeModel", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("ID");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("id"));

                    b.Property<int>("code")
                        .HasColumnType("integer")
                        .HasColumnName("BadgeCode");

                    b.HasKey("id");

                    b.ToTable("Badge");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.BadgeUserModel", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("ID");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("id"));

                    b.Property<int>("BadgeCode")
                        .HasColumnType("integer");

                    b.Property<int>("User")
                        .HasColumnType("integer");

                    b.HasKey("id");

                    b.HasIndex("BadgeCode");

                    b.HasIndex("User");

                    b.ToTable("BadgeUser");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.BookGenreModel", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("ID");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("id"));

                    b.Property<int>("Book")
                        .HasColumnType("integer");

                    b.Property<int>("Genre")
                        .HasColumnType("integer");

                    b.Property<int>("UserIdentifier")
                        .HasColumnType("integer");

                    b.HasKey("id");

                    b.HasIndex("Book");

                    b.HasIndex("Genre");

                    b.HasIndex("UserIdentifier");

                    b.ToTable("BookGenre");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.BookModel", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("ID");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("id"));

                    b.Property<string>("author")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("Author");

                    b.Property<string>("buyLink")
                        .HasMaxLength(500)
                        .HasColumnType("character varying(500)")
                        .HasColumnName("BuyLink");

                    b.Property<string>("coverLink")
                        .HasMaxLength(500)
                        .HasColumnType("character varying(500)")
                        .HasColumnName("CoverLink");

                    b.Property<DateTime>("createdAt")
                        .HasColumnType("timestamp with time zone")
                        .HasColumnName("CreatedAt");

                    b.Property<int?>("edition")
                        .HasColumnType("integer")
                        .HasColumnName("Edition");

                    b.Property<int?>("format")
                        .HasColumnType("integer")
                        .HasColumnName("Format");

                    b.Property<string>("isbn")
                        .IsRequired()
                        .HasMaxLength(17)
                        .HasColumnType("character varying(17)")
                        .HasColumnName("ISBN");

                    b.Property<DateTime>("lastModification")
                        .HasColumnType("timestamp with time zone")
                        .HasColumnName("LastModification");

                    b.Property<string>("observation")
                        .HasColumnType("text")
                        .HasColumnName("Obsevation");

                    b.Property<int>("ownerid")
                        .HasColumnType("integer");

                    b.Property<int?>("pagesNumber")
                        .HasColumnType("integer")
                        .HasColumnName("PagesNumber");

                    b.Property<int?>("publicationYear")
                        .HasColumnType("integer")
                        .HasColumnName("PublicationYear");

                    b.Property<string>("publisher")
                        .HasMaxLength(100)
                        .HasColumnType("character varying(100)")
                        .HasColumnName("Publisher");

                    b.Property<DateTime?>("readEndDay")
                        .HasColumnType("timestamp with time zone")
                        .HasColumnName("ReadEndDay");

                    b.Property<DateTime?>("readStartDay")
                        .HasColumnType("timestamp with time zone")
                        .HasColumnName("ReadStartDay");

                    b.Property<int?>("readStatus")
                        .HasColumnType("integer")
                        .HasColumnName("Readed");

                    b.Property<string>("synopsis")
                        .HasMaxLength(300)
                        .HasColumnType("character varying(300)")
                        .HasColumnName("Synopsis");

                    b.Property<string>("title")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("character varying(100)")
                        .HasColumnName("Title");

                    b.HasKey("id");

                    b.HasIndex("ownerid");

                    b.ToTable("Books");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.BookTagModel", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("ID");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("id"));

                    b.Property<int>("BookId")
                        .HasColumnType("integer");

                    b.Property<int>("TagId")
                        .HasColumnType("integer");

                    b.HasKey("id");

                    b.HasIndex("BookId");

                    b.HasIndex("TagId");

                    b.ToTable("BookTag");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.EmailUserIdentifier", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("ID");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("id"));

                    b.Property<int?>("UserIdentifier")
                        .HasColumnType("integer");

                    b.Property<string>("email")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("Email");

                    b.HasKey("id");

                    b.HasIndex("UserIdentifier");

                    b.ToTable("EmailUserIdentifier");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.GenreModel", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("ID");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("id"));

                    b.Property<string>("genre")
                        .IsRequired()
                        .HasMaxLength(50)
                        .HasColumnType("character varying(50)")
                        .HasColumnName("Genre");

                    b.HasKey("id");

                    b.HasIndex("genre")
                        .IsUnique();

                    b.ToTable("Genres");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.TagModel", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("ID");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("id"));

                    b.Property<string>("tag")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("Tag");

                    b.HasKey("id");

                    b.HasIndex("tag")
                        .IsUnique();

                    b.ToTable("Tags");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.UserIdentifier", b =>
                {
                    b.Property<int>("id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("integer")
                        .HasColumnName("ID");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<int>("id"));

                    b.Property<string>("userIdentifier")
                        .IsRequired()
                        .HasColumnType("text")
                        .HasColumnName("UserIdentifier");

                    b.HasKey("id");

                    b.HasIndex("userIdentifier")
                        .IsUnique();

                    b.ToTable("UserIdentifier");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.BadgeUserModel", b =>
                {
                    b.HasOne("VolumeVaultInfra.Book.Hug.Models.Base.BadgeModel", "badge")
                        .WithMany()
                        .HasForeignKey("BadgeCode")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("VolumeVaultInfra.Book.Hug.Models.Base.UserIdentifier", "userIdentifier")
                        .WithMany()
                        .HasForeignKey("User")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("badge");

                    b.Navigation("userIdentifier");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.BookGenreModel", b =>
                {
                    b.HasOne("VolumeVaultInfra.Book.Hug.Models.Base.BookModel", "book")
                        .WithMany()
                        .HasForeignKey("Book")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("VolumeVaultInfra.Book.Hug.Models.Base.GenreModel", "genre")
                        .WithMany()
                        .HasForeignKey("Genre")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("VolumeVaultInfra.Book.Hug.Models.Base.UserIdentifier", "userIdentifier")
                        .WithMany()
                        .HasForeignKey("UserIdentifier")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("book");

                    b.Navigation("genre");

                    b.Navigation("userIdentifier");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.BookModel", b =>
                {
                    b.HasOne("VolumeVaultInfra.Book.Hug.Models.Base.UserIdentifier", "owner")
                        .WithMany()
                        .HasForeignKey("ownerid")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("owner");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.BookTagModel", b =>
                {
                    b.HasOne("VolumeVaultInfra.Book.Hug.Models.Base.BookModel", "book")
                        .WithMany()
                        .HasForeignKey("BookId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("VolumeVaultInfra.Book.Hug.Models.Base.TagModel", "tag")
                        .WithMany()
                        .HasForeignKey("TagId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("book");

                    b.Navigation("tag");
                });

            modelBuilder.Entity("VolumeVaultInfra.Book.Hug.Models.Base.EmailUserIdentifier", b =>
                {
                    b.HasOne("VolumeVaultInfra.Book.Hug.Models.Base.UserIdentifier", "userIdentifier")
                        .WithMany()
                        .HasForeignKey("UserIdentifier");

                    b.Navigation("userIdentifier");
                });
#pragma warning restore 612, 618
        }
    }
}
