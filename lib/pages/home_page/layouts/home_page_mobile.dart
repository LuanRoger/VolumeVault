import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/authorization_status.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/home_page/sections/home_section.dart';
import 'package:volume_vault/providers/providers.dart';

class HomePageMobile extends HookConsumerWidget {
  const HomePageMobile({super.key});

  Future<bool> _checkConnection(WidgetRef ref) async {
    final utilsController = await ref.read(utilsControllerProvider.future);

    return !(await utilsController.ping());
  }

  Future<bool> _checkUserAuthToken(WidgetRef ref) async {
    final utilsController = await ref.read(utilsControllerProvider.future);
    final userSession = await ref.read(userSessionNotifierProvider.future);
    if (userSession.token.isEmpty) return false;

    final result = await utilsController.checkAuthorizationStatus(userSession.token);

    return result != AuthorizationStatus.authorized;
  }

  Future<List<bool>> _checkout(WidgetRef ref) async {
    final bool connection = await _checkConnection(ref);
    final bool token = await _checkUserAuthToken(ref);

    return [connection, token];
  }

  void _showErrorDialog(BuildContext context,
      {required bool connectionError, required bool authValidationError}) {
    final String message = authValidationError
        ? "Não foi possível validar o token de autenticação. Faça login novamente."
        : "Não foi possível conectar ao servidor";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Um problema ocorreu"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutMemoize = useMemoized(() => _checkout(ref));
    final checkout = useFuture(checkoutMemoize);

    if (checkout.hasData && checkout.data!.contains(true)) {
      Future.delayed(
        Duration.zero,
        () => _showErrorDialog(context,
            connectionError: checkout.data![0],
            authValidationError: checkout.data![1]),
      );
    }

    return Scaffold(
      body: checkout.connectionState == ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : HomeSection(
              viewType: VisualizationType.LIST,
            ),
    );
  }
}
