import 'package:time_manage_client/http/dio_util.dart';
import 'package:time_manage_client/models/pie_model/pie_model.dart';

class StatisticApi {
  static final DioUtil _dio = DioUtil();

  static Future<List<PieModel>> getPieValue({
    required List<int> categoryIDs,
    required int endTime,
    required int startTime,
  }) async {
    final List<dynamic> response = await _dio.post(
      url: '/statistic/pie',
      data: <String, Object>{
        'categoryIDs': categoryIDs,
        'endTime': endTime,
        'startTime': startTime
      },
    );
    return response.map((dynamic e) => PieModel.fromJson(e)).toList();
  }
}
