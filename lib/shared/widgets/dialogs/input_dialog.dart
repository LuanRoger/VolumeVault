import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputDialog {
  Icon? icon;
  String? title;
  final List<Widget>? actions;
  Widget? textFieldLabel;
  Icon? prefixIcon;
  TextEditingController controller;

  InputDialog(
      {required this.controller,
      this.icon,
      this.title,
      this.actions,
      this.textFieldLabel,
      this.prefixIcon});

  Future show(BuildContext context) async {
    String textMemento = controller.text;

    await showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (context) => AlertDialog(
              alignment: Alignment.center,
              title: title != null ? Text(title!) : null,
              icon: icon,
              content: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      label: textFieldLabel ?? const Text("Enter a value"),
                      filled: true,
                      prefixIcon: prefixIcon,
                      border: const UnderlineInputBorder())),
              actions: [
                TextButton(
                    onPressed: () {
                      controller.text = textMemento;
                      Navigator.pop(context);
                    },
                    child:
                        Text(AppLocalizations.of(context)!.cancelDialogButton)),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                        AppLocalizations.of(context)!.confirmDialogButton)),
                ...?actions
              ],
            ));
  }
}
