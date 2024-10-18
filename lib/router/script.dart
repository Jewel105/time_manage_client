import 'dart:io';

void main() {
  // 获取路由文件内容
  var path = './lib/router/create_routes.dart';
  var res = File(path).readAsStringSync();

  // 提取路由名称
  RegExp regExp = RegExp("['\"]/(.*?)['\"]: "); // 匹配引号中的内容
  Iterable<Match> matches = regExp.allMatches(res);
  var list = matches.map((match) => match.group(1)).toList();

  // 拼接格式：static const String step1 = '/step1';
  final String s = list.map((e) {
    if (e?.isEmpty ?? true) {
      return "  static const String home = '/$e';";
    }
    return "  static const String $e = '/$e';";
  }).join('\n');

  // 替换模版
  String template = '''
class Routes {
%s
}
''';
  template = template.replaceAll("%s", s);

  // 写入文件
  File('./lib/router/routes.dart').writeAsStringSync(template);
}
