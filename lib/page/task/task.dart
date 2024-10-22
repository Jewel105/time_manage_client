import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/router/routes.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/main_button.dart';

class Task extends StatelessWidget {
  const Task({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.task),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 24.w,
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              DateTime? time = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 1095)),
                lastDate: DateTime.now(),
              );
              print(time);
              if (time == null) return;
              print(time.millisecondsSinceEpoch);

              // showTimePicker(
              //   context: context,
              //   initialTime: TimeOfDay.now(),
              // );
            },
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: <Widget>[
                  Text(StringUtil.dateTimeFormat(
                    context,
                    time: DateTime.now().millisecondsSinceEpoch,
                    format: DateFormat.yMMMEd,
                  )),
                  const Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
          Container(),
          MainButton(
              text: "register",
              onPressed: () {
                NavCtrl.push(Routes.register);
              }),
          MainButton(
              text: "forgot password",
              onPressed: () {
                NavCtrl.push(Routes.forgot);
              }),
        ],
      ),
    );
  }
}
