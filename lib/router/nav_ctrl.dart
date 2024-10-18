import 'package:flutter/material.dart';

// 全局key，用于无context跳转的情况
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavCtrl {
  // 无context跳转
  static Future<dynamic> push(
    String path, {
    Object? arguments,
  }) {
    return Navigator.of(navigatorKey.currentContext!)
        .pushNamed(path, arguments: arguments);
  }

  // 无context replase
  static Future<dynamic> replease(
    String path, {
    Object? arguments,
  }) {
    return Navigator.of(navigatorKey.currentContext!)
        .pushReplacementNamed(path, arguments: arguments);
  }

  // 无context，清空路由栈跳转，一般用于跳转首页这种情况
  static Future<dynamic> switchTab(
    String path, {
    Object? arguments,
  }) {
    return Navigator.of(navigatorKey.currentContext!)
        .pushNamedAndRemoveUntil(path, (_) => false, arguments: arguments);
  }

  // 无context返回,并指定路由返回多少层，默认返回上一页面, 返回带参数params
  static void back({int count = 1, Object? arguments}) {
    NavigatorState state = Navigator.of(navigatorKey.currentContext!);
    while (count-- > 0) {
      if (state.canPop()) state = state..pop(arguments);
    }
  }
}
