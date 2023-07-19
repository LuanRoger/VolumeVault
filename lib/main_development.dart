import "dart:developer";

import "package:flutter/foundation.dart";
import "package:volume_vault/app.dart";
import "package:volume_vault/bootstrap.dart";

void main() {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  bootstrap(() => const App());
}
