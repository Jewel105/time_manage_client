import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:time_manage_client/api/category_api.dart';
import 'package:time_manage_client/api/task_api.dart';
import 'package:time_manage_client/common/app_style.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/models/task_model/task_model.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/utils/extension_util.dart';
import 'package:time_manage_client/utils/string_util.dart';
import 'package:time_manage_client/widget/main_button.dart';

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
  final TreeNode<CategoryModel> sampleTree = TreeNode<CategoryModel>.root();

  @override
  void initState() {
    super.initState();
    initData();
    getCategories(sampleTree);
  }

  initData() async {
    task = widget.task;
    if (task.id != 0) return;
    task.endTime = DateTime.now().millisecondsSinceEpoch;
    if (task.startTime == 0) {
      task.startTime = await TaskApi.getLastTime();
      if (task.startTime == 0) {
        task.startTime = DateTime.now().millisecondsSinceEpoch;
      }
      print(task.startTime); //1729689618185
      print(task.endTime); //1729693219932
      setState(() {});
    }
  }

  getCategories(TreeNode<CategoryModel> node) async {
    if (node.childrenAsList.isNotEmpty) return;
    if (task.categoryID == node.data?.id) return;
    List<CategoryModel> res =
        await CategoryApi.getCategories(parentID: node.data?.id ?? 0);
    if (res.isEmpty) {
      task.categoryID = node.data?.id ?? 0;
      setState(() {});
      return;
    }
    List<TreeNode<CategoryModel>> treeDate = res
        .map((CategoryModel e) =>
            TreeNode<CategoryModel>(data: e, key: e.id.toString()))
        .toList();
    node.addAll(treeDate);
  }

  _saveTask() async {
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
              obscureText: true,
            ),
            SizedBox(height: 16.h),
            Text(context.locale.selectCategory, style: AppStyle.h3),
            Expanded(
              child: TreeView.simple(
                tree: sampleTree,
                showRootNode: false,
                builder: (BuildContext context, TreeNode<CategoryModel> node) {
                  return Container(
                    color:
                        node.data?.id == task.categoryID ? Colors.amber : null,
                    child: ListTile(
                      title: Text('${node.data?.name}'),
                    ),
                  );
                },
                onItemTap: getCategories,
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
