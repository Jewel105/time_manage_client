import 'package:flutter/material.dart';
import 'package:time_manage_client/page/common/page_404.dart';
import 'package:time_manage_client/page/index_page.dart';

typedef WidgetBuilder = Widget Function(Object? arguments);

class CreateRoutes {
  static final routes = <String, WidgetBuilder>{
    '/': (arguments) => const IndexPage(),
  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final Widget widget =
        routes[settings.name]?.call(settings.arguments) ?? const Page404();
    return MaterialPageRoute(builder: (context) => widget);
  }
}
