import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:time_manage_client/api/task_api.dart';
import 'package:time_manage_client/models/task_model/task_model.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/list_view_wrapper.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  int selectTime = 0;
  late final PageApiCall<TaskModel> pageApiCall;
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    selectTime = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    pageApiCall = PageApiCall<TaskModel>(
      apiCall: TaskApi.getCategories,
      params: <String, dynamic>{
        'startTime': selectTime,
        'endTime': now.millisecondsSinceEpoch,
      },
    );
  }

  void _changeDate() async {
    DateTime now = DateTime.now();
    DateTime? time = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 1095)),
      lastDate: now,
    );
    if (time == null) return;
    selectTime = time.millisecondsSinceEpoch;
    int endTime = time.add(const Duration(days: 1)).millisecondsSinceEpoch;
    pageApiCall.refresh();
    pageApiCall.params = <String, dynamic>{
      'startTime': selectTime,
      'endTime': endTime,
    };
    setState(() {});
    await pageApiCall.loadMore();
    setState(() {});
    // showTimePicker(
    //   context: context,
    //   initialTime: TimeOfDay.now(),
    // );
  }

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
          _buildDate(),
          Expanded(
              child: ListViewWrapper<TaskModel>(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(index.toString()),
              );
            },
            pageApiCall: pageApiCall,
          )),
        ],
      ),
    );
  }

  GestureDetector _buildDate() {
    return GestureDetector(
      onTap: _changeDate,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: <Widget>[
            Text(StringUtil.dateTimeFormat(
              context,
              time: selectTime,
              format: DateFormat.yMMMEd,
            )),
            const Icon(Icons.keyboard_arrow_down)
          ],
        ),
      ),
    );
  }
}
