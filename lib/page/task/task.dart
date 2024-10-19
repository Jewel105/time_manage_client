import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:time_manage_client/utils/index.dart';

class Task extends StatelessWidget {
  const Task({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(DateTime.now().toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.task),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${StringUtil.dateTimeFormat(
                  context,
                  time: DateTime.now().millisecondsSinceEpoch,
                  format: DateFormat.yMMMEd,
                )}⬇️'),
                Text('+${context.locale.addTask}'),
              ],
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
