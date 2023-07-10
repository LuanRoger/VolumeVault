part of '../providers/providers.dart';

final bookControllerProvider = FutureProvider<BookController>((ref) async {
  final service = await ref.watch(_bookServiceProvider.future);

  return BookController(service: service);
});
final bookSearchControllerProvider =
    FutureProvider<BookSearchController>((ref) async {
  final service = await ref.watch(_bookSearchServiceProvider.future);

  return BookSearchController(service: service);
});
final badgeControllerProvider = FutureProvider<BadgeController>((ref) async {
  final service = await ref.watch(_badgeServiceProvider.future);

  return BadgeController(service: service);
});
final statsControllerProvider = FutureProvider<StatsController>((ref) async {
  final service = await ref.watch(_statsServiceProvider.future);

  return StatsController(service: service);
});
