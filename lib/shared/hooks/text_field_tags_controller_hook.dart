import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:textfield_tags/textfield_tags.dart';

TextfieldTagsController useTextfieldTagsController() =>
    use(_TextfieldTagsControllerHook());

class _TextfieldTagsControllerHook extends Hook<TextfieldTagsController> {
  @override
  HookState<TextfieldTagsController, Hook<TextfieldTagsController>>
      createState() => _TextfieldTagsControllerHookState();
}

class _TextfieldTagsControllerHookState
    extends HookState<TextfieldTagsController, _TextfieldTagsControllerHook> {
  late final TextfieldTagsController controller;

  @override
  void initHook() {
    super.initHook();
    controller = TextfieldTagsController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  TextfieldTagsController build(BuildContext context) {
    return controller;
  }
}
