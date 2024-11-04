import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/api/statistic_api.dart';
import 'package:time_manage_client/common/app_color.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/models/pie_model/pie_model.dart';
import 'package:time_manage_client/utils/index.dart';

class PieWidget extends StatefulWidget {
  const PieWidget(
      {super.key, required this.categories, required this.selectedDates});
  final ValueNotifier<List<CategoryModel>> categories;
  final ValueNotifier<List<DateTime>> selectedDates;

  @override
  State<PieWidget> createState() => PieWidgetState();
}

class PieWidgetState extends State<PieWidget> {
  int touchedIndex = -1;
  List<PieModel> rowValue = <PieModel>[];
  int totalValue = 1;

  @override
  void initState() {
    super.initState();
    showingSections();
  }

  @override
  void didUpdateWidget(PieWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    showingSections();
  }

  Future<void> showingSections() async {
    rowValue = await StatisticApi.getPieValue(
      categories: widget.categories.value,
      endTime: widget.selectedDates.value.last.millisecondsSinceEpoch,
      startTime: widget.selectedDates.value.first.millisecondsSinceEpoch,
    );
    totalValue =
        rowValue.reduce((PieModel a, PieModel b) => a + b).value; // 计算总和
    setState(() {});
  }

  List<PieChartSectionData> get pieValue {
    return rowValue.map((PieModel pieModel) {
      int index = rowValue.indexOf(pieModel);
      final bool isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 14.sp : 12.sp;
      final double radius = isTouched ? 0.32.sw : 0.3.sw;
      final List<Shadow> shadows = <Shadow>[
        Shadow(color: Colors.black, blurRadius: 2.w)
      ];
      String percent = StringUtil.addPercent(pieModel.value / totalValue);
      return PieChartSectionData(
        color: AppColor.colors[pieModel.categoryID % AppColor.colors.length],
        value: pieModel.value.toDouble(),
        title:
            '${pieModel.categoryName}\n${StringUtil.formatDuration(context, pieModel.value)}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          shadows: shadows,
        ),
        badgeWidget: Text(
          percent,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
        ),
        badgePositionPercentageOffset: 1.1,
        titlePositionPercentageOffset: 0.55,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback:
                (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
              setState(() {});
            },
          ),
          sectionsSpace: 2.w,
          centerSpaceRadius: 0,
          sections: pieValue,
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 8.w,
          height: 8.w,
          color: color,
        ),
        Text(text),
      ],
    );
  }
}
