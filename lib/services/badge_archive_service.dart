import "package:volume_vault/models/api_config_params.dart";
import "package:volume_vault/models/http_code.dart";
import "package:volume_vault/models/http_response.dart";
import "package:volume_vault/models/interfaces/http_module.dart";
import "package:volume_vault/models/user_badge_model.dart";
import "package:volume_vault/shared/consts.dart";

class BadgeArchiveService {
  late final HttpModule _httpModule;
  final ApiConfigParams _apiConfig;
  final String userIdentifier;

  BadgeArchiveService(
      {required ApiConfigParams apiConfig, required this.userIdentifier})
      : _apiConfig = apiConfig {
    _httpModule = HttpModule(fixHeaders: {
      Consts.API_KEY_REQUEST_HEADER: _apiConfig.apiKey,
    });
  }

  String get _baseUrl =>
      "${_apiConfig.protocol}://${_apiConfig.host}:${_apiConfig.port}/badge/archive";

  Future<UserBadgeModel?> getUserBadgesOnArchive(String email) async {
    final queryParams = {"email": email};

    HttpResponse response = await _httpModule.get(_baseUrl, query: queryParams);
    if (response.statusCode != HttpCode.OK || response.body is! Map) {
      return null;
    }

    UserBadgeModel userBadgeModel =
        UserBadgeModel.fromJson(response.body as Map<String, dynamic>);
    return userBadgeModel;
  }
}
