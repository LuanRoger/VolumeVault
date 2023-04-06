import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:volume_vault/pages/login_user_page/layouts/login_user_page_desktop.dart';
import 'package:volume_vault/pages/login_user_page/layouts/login_user_page_mobile.dart';

class LoginUserPage extends StatelessWidget {
  const LoginUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.of(context).isDesktop ?
      LoginUserPageDesktop() :
      LoginUserPageMobile();
  }
}