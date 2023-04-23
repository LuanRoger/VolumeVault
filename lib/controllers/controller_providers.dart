part of '../providers/providers.dart';

final bookControllerProvider = FutureProvider<BookController>((ref) async {
  final service = await ref.watch(_bookServiceProvider.future);

  return BookController(service: service);
});
final authControllerProvider = FutureProvider<AuthController>((ref) async {
  final service = await ref.watch(_authServiceProvider.future);

  return AuthController(service);
});
final statsControllerProvider = FutureProvider<StatsController>((ref) async {
  final service = await ref.watch(_statsServiceProvider.future);

  return StatsController(service: service);
});
final utilsControllerProvider = FutureProvider<UtilsController>((ref) async {
  final service = await ref.watch(_utilsServiceProvider.future);

  return UtilsController(service);
});
