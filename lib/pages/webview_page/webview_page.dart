import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:volume_vault/shared/hooks/webview_controller_widget.dart";
import "package:webview_flutter/webview_flutter.dart";

class WebViewPage extends HookWidget {
  final String initialUrl;
  final bool Function(String)? destinationBuilder;
  final bool Function(String)? restrictorBuilder;
  final void Function(BuildContext)? onDestinationReach;
  final void Function(BuildContext)? onRestrictorReach;

  const WebViewPage(
      {required this.initialUrl,
      this.destinationBuilder,
      this.restrictorBuilder,
      this.onDestinationReach,
      this.onRestrictorReach,
      super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useWebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            final isDestination = destinationBuilder?.call(url) ?? false;
            if (isDestination) {
              onDestinationReach?.call(context);
              return;
            }

            final isRestrictor = restrictorBuilder?.call(url) ?? false;
            if (isRestrictor) {
              onRestrictorReach?.call(context);
              return;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));

    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
