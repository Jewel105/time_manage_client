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
  DateTime selectTime = DateTime.now();
  DateTime today = DateTime.now();
  int selectedCategoryID = 0;
  final TextEditingController remarkController = TextEditingController();
  final TreeNode<CategoryModel> sampleTree = TreeNode<CategoryModel>.root();

  @override
  void initState() {
    super.initState();
    getCategories(sampleTree);
  }

  _changeDate() async {
    Locale currentLocale = Localizations.localeOf(context);
    DateTime? res = await DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      currentTime: selectTime,
      minTime: today.subtract(const Duration(days: 365)),
      maxTime: today,
      locale:
          currentLocale.languageCode == 'zh' ? LocaleType.zh : LocaleType.en,
    );
    if (res != null) selectTime = res;
  }

  getCategories(TreeNode<CategoryModel> node) async {
    if (node.childrenAsList.isNotEmpty) return;
    if (selectedCategoryID == node.data?.id) return;
    List<CategoryModel> res =
        await CategoryApi.getCategories(parentID: node.data?.id ?? 0);
    if (res.isEmpty) {
      selectedCategoryID = node.data?.id ?? 0;
      setState(() {});
      return;
    }
    List<TreeNode<CategoryModel>> treeDate = res
        .map((CategoryModel e) =>
            TreeNode<CategoryModel>(data: e, key: e.id.toString()))
        .toList();
    node.addAll(treeDate);
  }

  _saveTask() {
    TaskModel task = widget.task;
    task.categoryID = selectedCategoryID;
    task.description = remarkController.text;
    task.endTime = selectTime.millisecondsSinceEpoch;
    TaskApi.saveTask(task);
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
              context.locale.startTime,
              style: AppStyle.h3,
            ),
            SizedBox(height: 4.h),
            Text(
              widget.task.startTime != 0
                  ? StringUtil.dateTimeFormat(
                      context,
                      time: selectTime.millisecondsSinceEpoch,
                      format: DateFormat.yMMMEd,
                      timeFormat: 'Hm',
                    )
                  : context.locale.startTimeTip,
              style: AppStyle.tip,
            ),
            SizedBox(height: 8.h),
            Text(
              context.locale.endTime,
              style: AppStyle.h3,
            ),
            SizedBox(height: 4.h),
            _buildDate(),
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
                  print("object");
                  return Container(
                    color: node.data?.id == selectedCategoryID
                        ? Colors.amber
                        : null,
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
          onPressed: selectedCategoryID != 0 ? _saveTask : null,
        ),
      ),
    );
  }

  GestureDetector _buildDate() {
    return GestureDetector(
      onTap: _changeDate,
      child: Row(
        children: <Widget>[
          Text(
            StringUtil.dateTimeFormat(
              context,
              time: selectTime.millisecondsSinceEpoch,
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
