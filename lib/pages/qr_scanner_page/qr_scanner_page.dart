import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:mobile_scanner/mobile_scanner.dart";
import "package:volume_vault/models/book_model.dart";
import "package:volume_vault/pages/qr_scanner_page/widgets/detected_book_preview.dart";
import "package:volume_vault/shared/hooks/qr_scanner_controller_hook.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QrScannerPage extends HookConsumerWidget {
  const QrScannerPage({super.key});

  BookModel? _decodeBookFromQrCode(String base64Book) {
    late final BookModel? decodedBook;
    try {
      final String jsonBook = utf8.decode(base64.decode(base64Book));
      final Map<String, dynamic> bookMap = json.decode(jsonBook);
      decodedBook = BookModel.fromJson(bookMap);
    } catch (_) {
      decodedBook = null;
    }

    return decodedBook;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannerController = useQrScannerController(
      useFrontCamera: true,
    );
    final detectedBookState = useState<BookModel?>(null);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: MobileScanner(
          onDetect: (capture) {
            if (capture.barcodes.isNotEmpty &&
                capture.barcodes.first.rawValue != null) {
              final String base64Book = capture.barcodes.first.rawValue!;
              final BookModel? book = _decodeBookFromQrCode(base64Book);
              detectedBookState.value = book;
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton.filled(
                      icon: scannerController.torchEnabled
                          ? const Icon(LucideIcons.zap)
                          : const Icon(LucideIcons.zapOff),
                      onPressed: () {
                        scannerController.toggleTorch();
                      },
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.cameraswitch_rounded),
                      onPressed: () {
                        scannerController.switchCamera();
                      },
                    ),
                  ],
                ),
                if (detectedBookState.value != null) ...[
                  DetectedBookPreview(book: detectedBookState.value!),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(detectedBookState.value!);
                          },
                          child: Text(
                              AppLocalizations.of(context)!.addQrDetectedInfo)),
                      const SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: () {
                            detectedBookState.value = null;
                          },
                          child: Text(
                              AppLocalizations.of(context)!.addQrDetectedInfo))
                    ],
                  )
                ]
              ],
            ),
          ),
        ));
  }
}
