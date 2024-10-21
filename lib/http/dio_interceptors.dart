import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_manage_client/common/constant.dart';
import 'package:time_manage_client/http/base_entity.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/router/routes.dart';
import 'package:time_manage_client/utils/index.dart';

class DioInterceptors extends Interceptor {
  // 请求拦截
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 添加token头
    String? token = StorageUtil.get(Constant.TOKEN) as String?;
    if (token != null) {
      options.headers['Token'] = token;
    }
    // 添加Equipment头
    int? equipment = StorageUtil.get(Constant.EQUIPMENTID) as int?;
    if (equipment != null) {
      options.headers['Equipment'] = equipment;
    }

    // 添加翻译请求头
    Locale? locale = navigatorKey.currentContext != null
        ? Localizations.localeOf(navigatorKey.currentContext!)
        : null;
    options.headers['Language'] = locale?.toString() ?? 'en';

    // 继续发送请求
    handler.next(options);
  }

  // 响应拦截
  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) async {
    BaseEntity<Object?> data =
        BaseEntity<Object?>.fromJson(response.data as Map<String, dynamic>);
    if (!data.success) {
      if (data.code == '301') {
        NavCtrl.switchTab(Routes.home);
      }
      DialogUtil.openDialog(
        titleText: data.msg.toString(),
        content: data.data.toString(),
      );
      handler.reject(DioException(
        requestOptions: response.requestOptions,
        message: data.msg ?? data.code,
      ));
      return;
    }
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    DialogUtil.openDialog(content: err.toString());
    handler.next(err);
  }
}
