import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/page/statistics/widget/statistics_select_category.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/custom_time_picker.dart';
import 'package:time_manage_client/widget/select_widget.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final SelectController typeController = SelectController()..code.value = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.statistics),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SelectWidget(
                  controller: typeController,
                  options: <SelectItem>[
                    SelectItem(value: context.locale.byDay, code: 1),
                    SelectItem(value: context.locale.byWeek, code: 2),
                    SelectItem(value: context.locale.byMonth, code: 3),
                    SelectItem(value: context.locale.byYear, code: 4),
                  ],
                ),
                const StatisticsSelectCategory(),
              ],
            ),
            ValueListenableBuilder<int>(
              valueListenable: typeController.code,
              builder: (BuildContext context, int typeCode, _) {
                return CustomTimePicker(typeCode: typeCode);
              },
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
