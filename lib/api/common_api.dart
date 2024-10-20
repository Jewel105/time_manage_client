import 'package:time_manage_client/http/dio_util.dart';

class CommonApi {
  static final DioUtil _dio = DioUtil();

  static Future<String> login(Map<String, dynamic> data) async {
    final String response =
        await _dio.post(url: '/common/user/login', data: data);
    return response;
  }

  static Future<String> register(Map<String, dynamic> data) async {
    final String response =
        await _dio.post(url: '/common/user/register', data: data);
    return response;
  }

  static Future<String> forgotPassword(Map<String, dynamic> data) async {
    final String response =
        await _dio.post(url: '/common/user/forget/password', data: data);
    return response;
  }

  static Future<String> sendCode(Map<String, dynamic> data) async {
    final String response =
        await _dio.post(url: '/common/user/send/code', data: data);
    return response;
  }
}
