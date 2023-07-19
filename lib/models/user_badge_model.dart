import "package:volume_vault/models/enums/badge_code.dart";

class UserBadgeModel {
  int count;
  List<BadgeCode> badges;

  UserBadgeModel({required this.count, required this.badges});

  factory UserBadgeModel.fromJson(Map<String, dynamic> json) {
    return UserBadgeModel(
      count: json["count"] as int,
      badges: (json["badgeCodes"] as List)
          .map<BadgeCode>((badgeValue) => BadgeCode.values[badgeValue as int])
          .toList(),
    );
  }
}
