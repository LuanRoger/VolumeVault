import "package:volume_vault/models/enums/qr_scanner_result_type.dart";
import "package:volume_vault/models/qr_sharable.dart";

class QrShare {
  final QrScannerResultType resultType;

  /// This object must to implement [toJson] method
  final QrSharable objectToSend;

  QrShare({required this.resultType, required this.objectToSend});

  Map<String, dynamic> toJson() => {
        "resultType": resultType.index,
        "info": objectToSend.toJson(),
      };
}
