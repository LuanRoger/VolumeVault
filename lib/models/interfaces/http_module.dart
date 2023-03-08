import 'package:dio/dio.dart';
import 'package:volume_vault/models/http_code.dart';
import 'package:volume_vault/models/http_response.dart';

class HttpModule {
  //Http client
  Dio get _dio {
    final dio = Dio();
    dio.options.headers = fixHeaders ?? const {};
    dio.options.connectTimeout = const Duration(seconds: 30);

    return dio;
  }

  final Map<String, String>? fixHeaders;

  HttpModule({this.fixHeaders});

  Future<HttpResponse> get(String url,
      {Map<String, String>? query, Map<String, String>? headers}) async {
    final Response response;
    try {
      response = await _dio.get(
        url,
        queryParameters: query ?? const {},
        options: Options(
          headers: Map.from({...?fixHeaders, ...?headers}),
        ),
      );
    } on DioError catch (e) {
      return HttpResponse.error(
          message: e.message, code: e.response?.statusCode);
    }

    return HttpResponse(
        statusCode: HttpCode.fromInt(response.statusCode ?? -1),
        body: response.data ?? "");
  }

  Future<HttpResponse> post(String url,
      {required String? body,
      Map<String, String>? query,
      Map<String, String>? headers}) async {
    final Response response;
    try {
      response = await _dio.post(
        url,
        data: body,
        options: Options(
          headers: Map.from({...?fixHeaders, ...?headers}),
        ),
      );
    } on DioError catch (e) {
      return HttpResponse.error(
          message: e.message, code: e.response?.statusCode);
    }

    return HttpResponse(
        statusCode: HttpCode.fromInt(response.statusCode ?? -1),
        body: response.data);
  }

  Future<HttpResponse> put(String url,
      {required dynamic body,
      Map<String, String>? query,
      Map<String, String>? headers}) async {
    final Response response;
    try {
      response = await _dio.put(
        url,
        data: body,
        options: Options(
          headers: Map.from({...?fixHeaders, ...?headers}),
        ),
      );
    } on DioError catch (e) {
      return HttpResponse.error(
          message: e.message, code: e.response?.statusCode);
    }

    return HttpResponse(
        statusCode: HttpCode.fromInt(response.statusCode ?? -1),
        body: response.data);
  }

  Future<HttpResponse> delete(String url,
      {Map<String, String>? query,
      bool includeFixedHeaders = true,
      Map<String, String>? headers}) async {
    final Response response;
    try {
      response = await _dio.delete(
        url,
        queryParameters: query ?? const {},
        options: Options(
          headers: Map.from({...?fixHeaders, ...?headers}),
        ),
      );
    } on DioError catch (e) {
      return HttpResponse.error(
          message: e.message, code: e.response?.statusCode);
    }

    return HttpResponse(
        statusCode: HttpCode.fromInt(response.statusCode ?? -1),
        body: response.data);
  }
}
