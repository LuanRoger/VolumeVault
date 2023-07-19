class ClaimBadgeRequestModel {
  final String email;
  final DateTime claimedAt;

  ClaimBadgeRequestModel({required this.email, required this.claimedAt});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "claimedAt": claimedAt.toUtc().toIso8601String(),
    };
  }
}
