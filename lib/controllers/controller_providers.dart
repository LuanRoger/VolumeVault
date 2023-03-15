import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/controllers/auth_controller.dart';
import 'package:volume_vault/controllers/book_controller.dart';

import '../providers/providers.dart';

final bookControllerProvider = FutureProvider<BookController>((ref) async {
  final service = await ref.watch(bookServiceProvider.future);

  return BookController(service: service);
});
final authControllerProvider = FutureProvider<AuthController>((ref) async {
  final service = await ref.watch(authServiceProvider.future);

  return AuthController(service);
});
