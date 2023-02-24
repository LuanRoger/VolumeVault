// ignore_for_file: constant_identifier_names

enum ApiProtocol {
  HTTP("HTTP", "http://"),
  HTTPS("HTTPS", "https://");

  final String name;
  final String addressName;

  const ApiProtocol(this.name, this.addressName);
}
