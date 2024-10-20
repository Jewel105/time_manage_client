import 'package:flutter/material.dart';
import 'package:time_manage_client/page/common/page_404.dart';
import 'package:time_manage_client/page/index_page.dart';
import 'package:time_manage_client/page/login/login_page.dart';
import 'package:time_manage_client/page/login/register_page.dart';

typedef WidgetBuilder = Widget Function(Object? arguments);

class CreateRoutes {
  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    '/': (Object? arguments) => const IndexPage(),
    '/login': (Object? arguments) => const LoginPage(),
    '/register': (Object? arguments) => const RegisterPage(),
  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final Widget widget =
        routes[settings.name]?.call(settings.arguments) ?? const Page404();
    return MaterialPageRoute<Object?>(
        builder: (BuildContext context) => widget);
  }
}
