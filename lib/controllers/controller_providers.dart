part of '../providers/providers.dart';

final bookControllerProvider = FutureProvider<BookController>((ref) async {
  final service = await ref.watch(_bookServiceProvider.future);

  return BookController(service: service);
});
final statsControllerProvider = FutureProvider<StatsController>((ref) async {
  final service = await ref.watch(_statsServiceProvider.future);

  return StatsController(service: service);
});
