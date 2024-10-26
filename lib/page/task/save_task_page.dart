import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/api/task_api.dart';
import 'package:time_manage_client/common/app_style.dart';
import 'package:time_manage_client/models/task_model/task_model.dart';
import 'package:time_manage_client/page/task/widget/time_picker.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/utils/extension_util.dart';
import 'package:time_manage_client/widget/main_button.dart';
import 'package:time_manage_client/widget/select_category.dart';

class SaveTaskPage extends StatefulWidget {
  const SaveTaskPage({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  State<SaveTaskPage> createState() => _SaveTaskPageState();
}

class _SaveTaskPageState extends State<SaveTaskPage> {
  late TaskModel task;
  DateTime today = DateTime.now();
  final TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    task = widget.task;
    remarkController.text = task.description;
    if (task.id != 0) return;
    task.endTime = DateTime.now().millisecondsSinceEpoch;
    if (task.startTime == 0) {
      task.startTime = await TaskApi.getLastTime();
      if (task.startTime == 0) {
        task.startTime = DateTime.now().millisecondsSinceEpoch;
      }
      setState(() {});
    }
  }

  _saveTask() async {
    task.description = remarkController.text;
    await TaskApi.saveTask(task);
    NavCtrl.back(arguments: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.id == 0
            ? context.locale.addTask
            : context.locale.editTask),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${context.locale.startTime}(${context.locale.startTimeTip})',
              style: AppStyle.h3,
            ),
            SizedBox(height: 4.h),
            TimePicker(
              currentTime: DateTime.fromMillisecondsSinceEpoch(task.startTime),
              onChangeTime: (DateTime time) {
                task.startTime = time.millisecondsSinceEpoch;
              },
            ),
            SizedBox(height: 8.h),
            Text(
              context.locale.endTime,
              style: AppStyle.h3,
            ),
            SizedBox(height: 4.h),
            TimePicker(
              currentTime: DateTime.fromMillisecondsSinceEpoch(task.endTime),
              onChangeTime: (DateTime time) {
                task.endTime = time.millisecondsSinceEpoch;
              },
            ),
            SizedBox(height: 16.h),
            FormBuilderTextField(
              name: 'remark',
              controller: remarkController,
              decoration: InputDecoration(labelText: context.locale.remark),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: SelectCategory(
                categoryID: task.categoryID,
                onChanged: (int id) {
                  task.categoryID = id;
                  setState(() {});
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.all(16.w),
        child: MainButton(
          width: double.infinity,
          text: context.locale.submit,
          onPressed: task.categoryID != 0 ? _saveTask : null,
        ),
      ),
    );
  }
}
