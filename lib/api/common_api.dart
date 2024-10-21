import 'package:time_manage_client/http/dio_util.dart';

class CommonApi {
  static final DioUtil _dio = DioUtil();

  static Future<String> login(Map<String, dynamic> data) async {
    final String response =
        await _dio.post(url: '/common/user/login', data: data);
    return response;
  }

  static Future<int> register(Map<String, dynamic> data) async {
    final int response = await _dio.post(
        url: '/common/user/register', data: data, loading: true);
    return response;
  }

  static Future<int> forgotPassword(Map<String, dynamic> data) async {
    final int response =
        await _dio.post(url: '/common/user/forget/password', data: data);
    return response;
  }

  static Future<bool> sendCode(String email) async {
    final bool response = await _dio.post(
      url: '/common/user/send/code',
      data: <String, String>{'email': email},
      loading: true,
    );
    return response;
  }

  static Future<int> registerDevice(Map<String, dynamic> data) async {
    final int response =
        await _dio.post(url: '/common/system/register/equipment', data: data);
    return response;
  }
}
