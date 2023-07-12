import "package:volume_vault/models/book_model.dart";
import "package:volume_vault/models/enums/qr_scanner_result_type.dart";

class QrShareRecive {
  final QrScannerResultType resultType;

  final Map<String, dynamic>? recivedInfo;

  QrShareRecive({required this.resultType, this.recivedInfo});

  BookModel? get getBookModel {
    if (resultType != QrScannerResultType.book || recivedInfo == null) {
      return null;
    }

    return BookModel.fromJson(recivedInfo!);
  }

  factory QrShareRecive.fromJson(Map<String, dynamic> json) => QrShareRecive(
        resultType: QrScannerResultType.values[json["resultType"] as int],
        recivedInfo: json["info"] as Map<String, dynamic>,
      );
}
