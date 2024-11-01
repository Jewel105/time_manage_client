import 'package:time_manage_client/http/dio_util.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/models/line_model/line_model.dart';
import 'package:time_manage_client/models/pie_model/pie_model.dart';

class StatisticApi {
  static final DioUtil _dio = DioUtil();

  static Future<List<PieModel>> getPieValue({
    required List<CategoryModel> categories,
    required int endTime,
    required int startTime,
  }) async {
    final List<dynamic> response = await _dio.post(
      url: '/statistic/pie',
      data: <String, Object>{
        'categories': categories
            .map((CategoryModel category) => category.toJson())
            .toList(),
        'endTime': endTime,
        'startTime': startTime
      },
    );
    return response.map((dynamic e) => PieModel.fromJson(e)).toList();
  }

  static Future<List<LineModel>> getLineValue({
    required List<CategoryModel> categories,
    required String timeType,
  }) async {
    final List<dynamic> response = await _dio.post(
      url: '/statistic/line',
      data: <String, Object>{
        'categories': categories
            .map((CategoryModel category) => category.toJson())
            .toList(),
        'timeType': timeType,
      },
    );
    return response.map((dynamic e) => LineModel.fromJson(e)).toList();
  }
}
