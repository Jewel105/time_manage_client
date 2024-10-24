import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:time_manage_client/common/app_style.dart';
import 'package:time_manage_client/utils/string_util.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({
    super.key,
    required this.currentTime,
    this.onChangeTime,
  });

  final DateTime currentTime;
  final void Function(DateTime)? onChangeTime;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late DateTime currentTime;
  @override
  void initState() {
    super.initState();
    currentTime = widget.currentTime;
  }

  @override
  void didUpdateWidget(TimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTime != currentTime) {
      currentTime = widget.currentTime;
    }
  }

  _changeDate() async {
    DateTime today = DateTime.now();
    Locale currentLocale = Localizations.localeOf(context);
    DateTime? res = await DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      currentTime: currentTime,
      minTime: today.subtract(const Duration(days: 365)),
      maxTime: today,
      locale:
          currentLocale.languageCode == 'zh' ? LocaleType.zh : LocaleType.en,
    );
    if (res != null) {
      currentTime = res;
      setState(() {});
      widget.onChangeTime?.call(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeDate,
      child: Row(
        children: <Widget>[
          Text(
            StringUtil.dateTimeFormat(
              context,
              time: currentTime.millisecondsSinceEpoch,
              format: DateFormat.yMMMEd,
              timeFormat: 'Hm',
            ),
            style: AppStyle.tip,
          ),
          const Icon(Icons.keyboard_arrow_down)
        ],
      ),
    );
  }
}
