import "package:volume_vault/models/api_config_params.dart";
import "package:volume_vault/models/http_code.dart";
import "package:volume_vault/models/http_response.dart";
import "package:volume_vault/models/interfaces/http_module.dart";
import "package:volume_vault/models/user_badge_model.dart";
import "package:volume_vault/shared/consts.dart";

class BadgeService {
  late final HttpModule _httpModule;
  final ApiConfigParams _apiConfig;
  final String userIdentifier;

  BadgeService(
      {required ApiConfigParams apiConfig, required this.userIdentifier})
      : _apiConfig = apiConfig {
    _httpModule = HttpModule(fixHeaders: {
      Consts.API_KEY_REQUEST_HEADER: _apiConfig.apiKey,
    });
  }

  String get _baseUrl =>
      "${_apiConfig.protocol}://${_apiConfig.host}:${_apiConfig.port}/badge";

  Future<UserBadgeModel?> getUserBadges(String userId) async {
    final queryParams = {"userId": userId};

    final response = await _httpModule.get(_baseUrl, query: queryParams);
    if (response.statusCode != HttpCode.ok || response.body is! Map) {
      return null;
    }

    final userBadgeModel =
        UserBadgeModel.fromJson(response.body as Map<String, dynamic>);
    return userBadgeModel;
  }
}
