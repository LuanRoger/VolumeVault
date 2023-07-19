import "package:volume_vault/models/enums/read_status.dart";

class ReadDateInfoModalModel {
  ReadStatus readStatus;
  DateTime? readStartDayText;
  DateTime? readEndDayText;

  ReadDateInfoModalModel(
      {required this.readStatus,
      required this.readStartDayText,
      required this.readEndDayText});
}
