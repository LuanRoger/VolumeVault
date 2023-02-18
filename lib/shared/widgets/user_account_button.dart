import 'package:flutter/material.dart';
import 'package:volume_vault/models/user_info_model.dart';

class UserAccountButton extends StatelessWidget {
  UserInfoModel userInfo;

  UserAccountButton(this.userInfo, {super.key});

  String get userCapChar => userInfo.username[0].toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
          color: Theme.of(context).colorScheme.primary),
      child: Center(
        child: Text(
          userCapChar,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
