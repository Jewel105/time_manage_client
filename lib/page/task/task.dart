import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:time_manage_client/api/task_api.dart';
import 'package:time_manage_client/common/app_style.dart';
import 'package:time_manage_client/models/task_model/task_model.dart';
import 'package:time_manage_client/page/task/widget/task_item.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/router/routes.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/list_view_wrapper.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> with AutomaticKeepAliveClientMixin {
  DateTime selectTime = DateTime.now();
  DateTime today = DateTime.now();

  late final PageApiCall<TaskModel> pageApiCall;

  int get endTimeMill {
    return DateTime(
            selectTime.year, selectTime.month, selectTime.day, 23, 59, 59)
        .millisecondsSinceEpoch;
  }

  @override
  void initState() {
    super.initState();
    selectTime = DateTime(today.year, today.month, today.day);
    pageApiCall = PageApiCall<TaskModel>(
      apiCall: TaskApi.getTasks,
      params: <String, dynamic>{
        'startTime': selectTime.millisecondsSinceEpoch,
        'endTime': endTimeMill,
      },
    );
  }

  void _changeDate() async {
    DateTime? time = await showDatePicker(
      context: context,
      initialDate: selectTime,
      firstDate: today.subtract(const Duration(days: 1095)),
      lastDate: today,
    );
    if (time == null) return;
    selectTime = time;
    pageApiCall.refresh();
    pageApiCall.params = <String, dynamic>{
      'startTime': selectTime.millisecondsSinceEpoch,
      'endTime': endTimeMill,
    };
    setState(() {});
  }

  void _saveTask(TaskModel task) async {
    bool? res = await NavCtrl.push(Routes.saveTask, arguments: task);
    if (res == true) {
      pageApiCall.refresh();
      pageApiCall.params = <String, dynamic>{
        'startTime': selectTime.millisecondsSinceEpoch,
        'endTime': endTimeMill,
      };
      setState(() {});
    }
  }

  void _deleteTask(int id) async {
    await TaskApi.deleteTask(id);
    pageApiCall.items.removeWhere((TaskModel item) => item.id == id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.task),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _saveTask(TaskModel.emptyInstance());
            },
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
            itemBuilder: (BuildContext context, TaskModel item) {
              return TaskItem(
                key: ValueKey<int>(item.id),
                item: item,
                onEdit: _saveTask,
                onDelete: _deleteTask,
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: <Widget>[
            Text(
              StringUtil.dateTimeFormat(
                context,
                time: selectTime.millisecondsSinceEpoch,
                format: DateFormat.yMMMEd,
              ),
              style: AppStyle.h3,
            ),
            const Icon(Icons.keyboard_arrow_down)
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
