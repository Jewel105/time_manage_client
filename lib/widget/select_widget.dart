import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/utils/index.dart';

class SelectItem {
  final String? value;
  final String code;
  SelectItem({this.value, required this.code});
}

class SelectController {
  ValueNotifier<String> code = ValueNotifier<String>('');
  SelectItem item = SelectItem(code: '', value: 'Please Select');
}

class SelectWidget extends StatefulWidget {
  const SelectWidget({
    super.key,
    this.controller,
    required this.options,
  });

  final SelectController? controller;
  final List<SelectItem> options;

  @override
  State<SelectWidget> createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget> {
  late SelectController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? SelectController();
    controller.item = widget.options.firstWhere(
      (SelectItem item) => item.code == controller.code.value,
      orElse: () => SelectItem(code: ''),
    );
  }

  void _showSelection() async {
    bool? res = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.options.length,
          itemBuilder: (BuildContext context, int index) {
            final SelectItem item = widget.options[index];
            return ListTile(
              title: Text(item.value ?? ''),
              onTap: () {
                controller.code.value = item.code;
                controller.item = item;
                NavCtrl.back(arguments: true);
              },
              selected: controller.code.value == item.code,
            );
          },
        ),
      ),
    );
    if (res == true) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSelection,
      child: Row(
        children: <Widget>[
          Text(controller.item.value ?? context.locale.pleaseSelect),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
