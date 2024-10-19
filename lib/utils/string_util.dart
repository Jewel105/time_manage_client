import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

typedef FormatFn<T> = DateFormat Function([dynamic locale]);

extension LocalizationExtension on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this);
}

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
      return DateFormat.yMd(AppLocalizations.of(context).localeName)
          .add_Hms()
          .format(dateTime);
    } else {
      switch (timeFormat) {
        case 'Hms':
          return format(AppLocalizations.of(context).localeName)
              .add_Hms()
              .format(dateTime);
        case 'Hm':
          return format(AppLocalizations.of(context).localeName)
              .add_Hm()
              .format(dateTime);
        case 'H':
          return format(AppLocalizations.of(context).localeName)
              .add_H()
              .format(dateTime);
        default:
          return format(AppLocalizations.of(context).localeName)
              .format(dateTime);
      }
    }
  }
}
