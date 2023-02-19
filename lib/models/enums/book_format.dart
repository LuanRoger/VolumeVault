// ignore_for_file: constant_identifier_names

enum BookFormat {
  HARDCOVER("Capa dura com proteção"),
  HARDBACK("Capa dura"),
  PAPERBACK("Bolso"),
  EBOOK("Digital");

  final String name;

  const BookFormat(this.name);
}
