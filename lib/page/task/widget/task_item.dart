import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:time_manage_client/common/app_style.dart';
import 'package:time_manage_client/models/task_model/task_model.dart';
import 'package:time_manage_client/utils/index.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.item,
    this.onEdit,
    this.onDelete,
  });
  final TaskModel item;
  final void Function(TaskModel)? onEdit;
  final void Function(int)? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        item.categories.replaceAll(',', '-'),
        style: AppStyle.h3,
      ),
      subtitle: Text(item.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                StringUtil.formatDuration(context, item.spentTime),
                style: AppStyle.h3,
              ),
              Text(
                '${StringUtil.dateTimeFormat(
                  context,
                  time: item.startTime,
                  format: DateFormat.Hm,
                )}-${StringUtil.dateTimeFormat(
                  context,
                  time: item.endTime,
                  format: DateFormat.Hm,
                )}',
                style: AppStyle.tip,
              ),
            ],
          ),
          IconButton(
            iconSize: 24.w,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              onEdit?.call(item);
            },
          ),
          IconButton(
            iconSize: 24.w,
            icon: const Icon(
              Icons.delete_outline,
            ),
            onPressed: () {
              onDelete?.call(item.id);
            },
          ),
        ],
      ),
    );
  }
}
