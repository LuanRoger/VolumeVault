import 'package:uno/uno.dart';
import 'package:volume_vault/models/http_code.dart';
import 'package:volume_vault/models/http_response.dart';

class HttpModule {
  //Http client
  final uno = Uno();

  final Map<String, String>? fixHeaders;

  HttpModule({this.fixHeaders});

  Future<HttpResponse> get(String url,
      {Map<String, String>? query, bool includeFixedHeaders = true}) async {
    final Response response = await uno.get(url,
        params: query ?? const {}, headers: fixHeaders ?? const {});

    return HttpResponse(
        statusCode: HttpCode.fromInt(response.status),
        body: response.data as String);
  }

  Future<HttpResponse> post(String url, {required dynamic data}) async {
    final Response response = await uno.post(url, data: data);

    return HttpResponse(
        statusCode: HttpCode.fromInt(response.status),
        body: response.data as String);
  }
}
