import "package:volume_vault/models/user_badge_model.dart";
import "package:volume_vault/services/badge_archive_service.dart";
import "package:volume_vault/services/models/claim_badge_request_model.dart";

class BadgeArchiveController {
  final BadgeArchiveService? _service;

  BadgeArchiveController({required BadgeArchiveService? service})
      : _service = service;

  Future<UserBadgeModel?> getUserBadgesOnArchive(String email) async {
    if (_service == null) return null;

    final userBadgeModel = await _service!.getUserBadgesOnArchive(email);
    return userBadgeModel;
  }

  Future<UserBadgeModel?> claimBadgesOnArchive(
      ClaimBadgeRequestModel request) async {
    if (_service == null) return null;

    final userBadgeModel = await _service!.claimBadgesOnArchive(request);
    return userBadgeModel;
  }
}
