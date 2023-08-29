import "package:flutter/material.dart";
import "package:responsive_framework/responsive_framework.dart";
import "package:volume_vault/pages/home_page/layouts/home_page_desktop.dart";
import "package:volume_vault/pages/home_page/layouts/home_page_mobile.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.of(context).isDesktop ||
            ResponsiveWrapper.of(context).isTablet
        ? const HomePageDesktop()
        : const HomePageMobile();
  }
}
