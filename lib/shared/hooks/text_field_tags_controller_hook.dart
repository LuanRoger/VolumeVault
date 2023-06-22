import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:textfield_tags/textfield_tags.dart';

TextfieldTagsController useTextfieldTagsController({List<String>? genres}) =>
    use(_TextfieldTagsControllerHook(genres: genres));

class _TextfieldTagsControllerHook extends Hook<TextfieldTagsController> {
  final List<String>? genres;

  const _TextfieldTagsControllerHook({this.genres});

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
    controller.initS(hook.genres, null, null, null);
  }

  @override
  void dispose() => controller.dispose();

  @override
  TextfieldTagsController build(BuildContext context) => controller;
}
