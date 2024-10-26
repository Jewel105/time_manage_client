import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/page/statistics/widget/select_widget.dart';
import 'package:time_manage_client/utils/index.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final SelectController typeController = SelectController()..code = 1;

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
            SelectWidget(
              controller: typeController,
              options: <SelectItem>[
                SelectItem(value: context.locale.byDay, code: 1),
                SelectItem(value: context.locale.byWeek, code: 2),
                SelectItem(value: context.locale.byMonth, code: 3),
              ],
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
