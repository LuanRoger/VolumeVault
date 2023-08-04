import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:webview_flutter/webview_flutter.dart";

WebViewController useWebViewController() => use(_WebViewControllerHook());

class _WebViewControllerHook extends Hook<WebViewController> {
  @override
  HookState<WebViewController, Hook<WebViewController>> createState() =>
      _WebViewControllerHookState();
}

class _WebViewControllerHookState
    extends HookState<WebViewController, _WebViewControllerHook> {
  late final WebViewController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = WebViewController();
  }

  @override
  WebViewController build(BuildContext context) => _controller;

  @override
  void dispose() {
    super.dispose();
  }
}
