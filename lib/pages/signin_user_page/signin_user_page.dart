import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:volume_vault/pages/signin_user_page/layouts/signin_user_page_desktop.dart';
import 'package:volume_vault/pages/signin_user_page/layouts/signin_user_page_mobile.dart';

class SigninUserPage extends StatelessWidget {
  const SigninUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.of(context).isDesktop
        ? SigninUserPageDesktop()
        : SigninUserPageMobile();
  }
}
