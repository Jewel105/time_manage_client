import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/select_category.dart';

class StatisticsSelectCategory extends StatefulWidget {
  const StatisticsSelectCategory({
    super.key,
    required this.categories,
  });
  final ValueNotifier<List<CategoryModel>> categories;

  @override
  State<StatisticsSelectCategory> createState() =>
      _StatisticsSelectCategoryState();
}

class _StatisticsSelectCategoryState extends State<StatisticsSelectCategory> {
  void _showSelection() async {
    bool? res = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.all(16.w),
        child: SelectCategory(
          multiselect: true,
          categories: widget.categories,
        ),
      ),
    );
    if (res == true) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSelection,
      child: Row(
        children: <Widget>[
          Text(context.locale.selectCategory),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
