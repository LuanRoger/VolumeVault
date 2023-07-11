import "package:volume_vault/models/enums/qr_scanner_result_type.dart";

class QrScannerDetectionInfo<T> {
  final QrScannerResultType resultType;
  final String? rawValue;
  final T detectedObject;

  QrScannerDetectionInfo(
      {required this.resultType, required this.detectedObject, this.rawValue});
}
