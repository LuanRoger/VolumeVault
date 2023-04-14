import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/home_page/commands/home_page_mobile_command.dart';
import 'package:volume_vault/pages/home_page/sections/layouts/home_section_mobile.dart';

class HomePageMobile extends HookConsumerWidget {
  // ignore: unused_field
  final HomePageMobileCommands _commands = const HomePageMobileCommands();

  const HomePageMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return const HomeSectionMobile(
            viewType: VisualizationType.LIST,
          );
  }
}
