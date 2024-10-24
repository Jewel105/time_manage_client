import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_manage_client/utils/extension_util.dart';

typedef FormatFn<T> = DateFormat Function([dynamic locale]);

class StringUtil {
  /// 日期格式化，根据不同国家显示不同的日期顺序
  /// 不传format，默认格式：2023/10/06 12:56:34；
  /// format:控制年月日，格式是：DateFormat.yMd DateFormat.Hms等
  /// timeFormat：控制时分秒，可选值：Hms，Hm，H
  static String dateTimeFormat(BuildContext context,
      {required int? time, FormatFn? format, String? timeFormat}) {
    if (time == null) return '';
    if (time.toString().length == 10) {
      time = time * 1000;
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    if (format == null) {
      return DateFormat.yMd(context.locale.localeName)
          .add_Hms()
          .format(dateTime);
    } else {
      switch (timeFormat) {
        case 'Hms':
          return format(context.locale.localeName).add_Hms().format(dateTime);
        case 'Hm':
          return format(context.locale.localeName).add_Hm().format(dateTime);
        case 'H':
          return format(context.locale.localeName).add_H().format(dateTime);
        default:
          return format(context.locale.localeName).format(dateTime);
      }
    }
  }

  /// 将毫秒转换为时间，支持中英文
  static String formatDuration(BuildContext context, int durationMs) {
    Duration duration = Duration(milliseconds: durationMs);
    String res = '';

    int hours = duration.inHours;
    if (hours != 0) res += '$hours ${context.locale.hours}';
    int minutes = (duration.inMinutes % 60);
    if (minutes != 0) res += '$minutes ${context.locale.minute}';
    return res;
  }
}
