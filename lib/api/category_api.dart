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

  static Future<int> saveCategory({
    int id = 0,
    required String name,
    int parentID = 0,
  }) async {
    final int response = await _dio.post(
        url: '/categories/save',
        data: <String, Object>{'id': id, 'name': name, 'parentID': parentID},
        loading: true);
    return response;
  }

  static Future<bool> deleteCategory(int id) async {
    final bool response =
        await _dio.post(url: '/categories/delete/$id', loading: true);
    return response;
  }
}
