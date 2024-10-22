import 'package:time_manage_client/http/dio_util.dart';
import 'package:time_manage_client/models/page_modle/page_modle.dart';

class TaskApi {
  static final DioUtil _dio = DioUtil();

  static Future<PageModle> getCategories({
    required int startTime,
    required int endTime,
    required int page,
    required int size,
  }) async {
    final Map<String, dynamic> response = await _dio.get(
      url: '/tasks/list',
      params: <String, int>{
        'startTime': startTime,
        'endTime': endTime,
        'page': page,
        'size': size,
      },
    );
    return response;
  }
}
