import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/home_page/commands/home_page_mobile_command.dart';
import 'package:volume_vault/pages/home_page/sections/layouts/home_section_mobile.dart';

class HomePageMobile extends HookConsumerWidget {
  final HomePageMobileCommands _commands = HomePageMobileCommands();

  HomePageMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutMemoize = useMemoized(() => _commands.checkout(context, ref));
    final checkout = useFuture(checkoutMemoize);

    return Scaffold(
      body: checkout.connectionState == ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : HomeSectionMobile(
              viewType: VisualizationType.LIST,
            ),
    );
  }
}
