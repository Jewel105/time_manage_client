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
  int selectTime = DateTime.now().millisecondsSinceEpoch;

  final PageApiCall<TaskModel> pageApiCall = PageApiCall<TaskModel>(
    apiCall: TaskApi.getCategories,
    params: <String, dynamic>{
      'startTime': 1728610830,
      'endTime': 1728610833,
    },
  );

  void _changeDate() async {
    DateTime? time = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1095)),
      lastDate: DateTime.now(),
    );
    if (time == null) return;
    selectTime = time.millisecondsSinceEpoch;
    pageApiCall.refresh();
    pageApiCall.params = {
      'startTime': 1728610833,
      'endTime': 1728610833,
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
