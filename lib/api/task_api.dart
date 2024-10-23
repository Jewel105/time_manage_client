import 'package:time_manage_client/http/dio_util.dart';
import 'package:time_manage_client/models/task_model/task_model.dart';

class TaskApi {
  static final DioUtil _dio = DioUtil();

  static Future<List<TaskModel>> getCategories(
      Map<String, dynamic> params) async {
    final List<dynamic> response = await _dio.get(
      url: '/tasks/list',
      params: params,
    );
    return response.map((dynamic data) => TaskModel.fromJson(data)).toList();
  }
}
