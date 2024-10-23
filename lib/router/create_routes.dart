import 'package:flutter/material.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/models/task_model/task_model.dart';
import 'package:time_manage_client/page/category/category.dart';
import 'package:time_manage_client/page/common/page_404.dart';
import 'package:time_manage_client/page/index_page.dart';
import 'package:time_manage_client/page/login/forgot_page.dart';
import 'package:time_manage_client/page/login/login_page.dart';
import 'package:time_manage_client/page/login/register_page.dart';
import 'package:time_manage_client/page/task/save_task_page.dart';

typedef WidgetBuilder = Widget Function(Object? arguments);

class CreateRoutes {
  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    '/': (Object? arguments) => const IndexPage(),
    '/login': (Object? arguments) => const LoginPage(),
    '/register': (Object? arguments) => const RegisterPage(),
    '/forgot': (Object? arguments) => const ForgotPage(),
    '/category': (Object? arguments) =>
        Category(parent: arguments as CategoryModel),
    '/saveTask': (Object? arguments) =>
        SaveTaskPage(task: arguments as TaskModel),
  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final Widget widget =
        routes[settings.name]?.call(settings.arguments) ?? const Page404();
    return MaterialPageRoute<Object?>(
        builder: (BuildContext context) => widget);
  }
}
