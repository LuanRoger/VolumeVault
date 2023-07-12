import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:volume_vault/models/enums/qr_scanner_result_type.dart";
import "package:volume_vault/models/qr_share_recive.dart";
import "package:volume_vault/shared/routes/app_routes.dart";

abstract class QrScannerStrategy {
  void acceptQrCode(QrShareRecive qrShareRecive,
      {required BuildContext context}) {
    if (qrShareRecive.recivedInfo == null) return;

    switch (qrShareRecive.resultType) {
      case QrScannerResultType.book:
        context.pushReplacement(AppRoutes.registerEditBookPageRoute,
            extra: [qrShareRecive.getBookModel!, false]);
      case QrScannerResultType.collection || QrScannerResultType.text:
        throw UnimplementedError();
    }
  }
}
