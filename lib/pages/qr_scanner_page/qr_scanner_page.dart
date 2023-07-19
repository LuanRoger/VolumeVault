import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:mobile_scanner/mobile_scanner.dart";
import "package:volume_vault/models/qr_share_recive.dart";
import "package:volume_vault/pages/qr_scanner_page/qr_scanner_command.dart";
import "package:volume_vault/pages/qr_scanner_page/widgets/detected_book_preview.dart";
import "package:volume_vault/shared/hooks/qr_scanner_controller_hook.dart";

class QrScannerPage extends HookConsumerWidget {
  final QrScannerCommand _command = QrScannerCommand();

  QrScannerPage({super.key});

  QrShareRecive? _decodeInfoFromQrCode(String base64Book) {
    late final QrShareRecive? decodedInfo;
    try {
      final jsonBook = utf8.decode(base64.decode(base64Book));
      final shareInfo = json.decode(jsonBook) as Map<String, dynamic>;
      decodedInfo = QrShareRecive.fromJson(shareInfo);
    } catch (_) {
      decodedInfo = null;
    }

    return decodedInfo;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannerController = useQrScannerController();
    final detectedBookState = useState<QrShareRecive?>(null);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: scannerController.torchEnabled
                ? const Icon(LucideIcons.zap)
                : const Icon(LucideIcons.zapOff),
            onPressed: scannerController.toggleTorch,
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch_rounded),
            onPressed: scannerController.switchCamera,
          ),
        ],
      ),
      body: MobileScanner(
        controller: scannerController,
        onDetect: (capture) {
          if (capture.barcodes.isNotEmpty &&
              capture.barcodes.first.rawValue != null) {
            final base64Book = capture.barcodes.first.rawValue!;
            final qrInfo = _decodeInfoFromQrCode(base64Book);
            detectedBookState.value = qrInfo;
          }
        },
      ),
      bottomSheet: AnimatedSize(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (detectedBookState.value != null) ...[
                QrDetectedInfoPreview(qrShare: detectedBookState.value!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _command.acceptQrCode(detectedBookState.value!,
                              context: context);
                        },
                        child: Text(
                            AppLocalizations.of(context)!.addQrDetectedInfo)),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () {
                          detectedBookState.value = null;
                        },
                        child: Text(
                            AppLocalizations.of(context)!.recuseQrDetectedInfo))
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
