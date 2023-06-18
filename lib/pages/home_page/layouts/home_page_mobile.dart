import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/pages/home_page/commands/home_page_mobile_command.dart';
import 'package:volume_vault/pages/home_page/sections/home_section/layouts/home_section_mobile.dart';

class HomePageMobile extends HookWidget {
  // ignore: unused_field
  final HomePageMobileCommands _commands = const HomePageMobileCommands();

  const HomePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: HomeSectionMobile(
      viewType: VisualizationType.LIST,
    ));
  }
}
