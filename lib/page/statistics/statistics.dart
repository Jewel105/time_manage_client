import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/page/statistics/widget/line_widget.dart';
import 'package:time_manage_client/page/statistics/widget/pie_widget.dart';
import 'package:time_manage_client/page/statistics/widget/statistics_select_category.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/custom_time_picker.dart';
import 'package:time_manage_client/widget/select_widget.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics>
    with AutomaticKeepAliveClientMixin {
  final SelectController typeController = SelectController()
    ..code.value = 'day';
  final ValueNotifier<List<CategoryModel>> categories =
      ValueNotifier<List<CategoryModel>>(<CategoryModel>[]);
  final ValueNotifier<List<DateTime>> selectedDates =
      ValueNotifier<List<DateTime>>(<DateTime>[]);
  final ValueNotifier<bool> refreshStatus = ValueNotifier<bool>(false);
  Future<void> _refresh() async {
    refreshStatus.value = !refreshStatus.value;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.statistics),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SelectWidget(
                      controller: typeController,
                      options: <SelectItem>[
                        SelectItem(value: context.locale.byDay, code: 'day'),
                        SelectItem(value: context.locale.byWeek, code: 'week'),
                        SelectItem(
                            value: context.locale.byMonth, code: 'month'),
                        SelectItem(value: context.locale.byYear, code: 'year'),
                      ],
                    ),
                    StatisticsSelectCategory(categories: categories),
                  ],
                ),
                SizedBox(height: 16.h),
                ValueListenableBuilder<String>(
                  valueListenable: typeController.code,
                  builder: (BuildContext context, String typeCode, _) {
                    return CustomTimePicker(
                      typeCode: typeCode,
                      selectedDates: selectedDates,
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: Listenable.merge(
                      <Listenable?>[categories, selectedDates, refreshStatus]),
                  builder: (BuildContext context, _) {
                    return PieWidget(
                      categories: categories,
                      selectedDates: selectedDates,
                    );
                  },
                ),
                SizedBox(height: 48.h),
                ListenableBuilder(
                    listenable: Listenable.merge(
                      <Listenable?>[
                        categories,
                        typeController.code,
                        refreshStatus
                      ],
                    ),
                    builder: (BuildContext context, _) {
                      return LineWidget(
                        categories: categories,
                        code: typeController.code,
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
