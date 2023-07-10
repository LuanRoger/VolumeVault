import "package:volume_vault/models/user_badge_model.dart";
import "package:volume_vault/services/badges_service.dart";

class BadgeController {
  final BadgeService? _service;

  BadgeController({required BadgeService? service}) : _service = service;

  Future<UserBadgeModel?> getUserBadges(String userId) async {
    if (_service == null) return null;

    UserBadgeModel? userBadgeModel = await _service!.getUserBadges(userId);
    return userBadgeModel;
  }
}
