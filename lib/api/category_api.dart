import 'package:time_manage_client/http/dio_util.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';

class CategoryApi {
  static final DioUtil _dio = DioUtil();

  static Future<List<CategoryModel>> getCategories({int parentID = 0}) async {
    final List<dynamic> response = await _dio.get(
      url: '/categories/list',
      params: <String, int>{'parentID': parentID},
    );
    return response
        .map((dynamic data) => CategoryModel.fromJson(data))
        .toList();
  }
}
