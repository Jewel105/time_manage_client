import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:time_manage_client/api/statistic_api.dart';
import 'package:time_manage_client/common/app_color.dart';
import 'package:time_manage_client/models/category_model/category_model.dart';
import 'package:time_manage_client/models/line_model/line_model.dart';
import 'package:time_manage_client/utils/index.dart';

class LineWidget extends StatefulWidget {
  const LineWidget({super.key, required this.categories, required this.code});
  final ValueNotifier<List<CategoryModel>> categories;
  final ValueNotifier<String> code;

  @override
  State<LineWidget> createState() => _LineWidgetState();
}

class _LineWidgetState extends State<LineWidget> {
  List<LineModel> rowValue = <LineModel>[];
  double intervalX = 0;
  double intervalY = 0;
  double reservedSizeY = 22;
  DateFormat formatX = DateFormat('dd');

  @override
  void initState() {
    super.initState();
    initData();
    _updateLineData();
  }

  @override
  void didUpdateWidget(LineWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateLineData();
    initData();
  }

  initData() {
    switch (widget.code.value) {
      case 'day':
        intervalY = 1000 * 60 * 60 * 4;
        intervalX = 1000 * 60 * 60 * 24;
        reservedSizeY = 22;
        formatX = DateFormat('dd');
        break;
      case 'week':
        intervalY = 1000 * 60 * 60 * 10;
        intervalX = 1000 * 60 * 60 * 24 * 7;
        reservedSizeY = 30;
        formatX = DateFormat('dd');
        break;
      case 'month':
        intervalY = 1000 * 60 * 60 * 50;
        intervalX = 1000 * 60 * 60 * 24 * 30;
        reservedSizeY = 40;
        formatX = DateFormat('M');
        break;
      case 'year':
        reservedSizeY = 50;
        intervalY = 1000 * 60 * 60 * 100;
        intervalX = 1000 * 60 * 60 * 24 * 365;
        formatX = DateFormat('yy');
        break;
      default:
        intervalY = 1000 * 60 * 60 * 3;
        intervalX = 1000 * 60 * 60 * 24;
        formatX = DateFormat('dd');
        break;
    }
  }

  void _updateLineData() async {
    rowValue = await StatisticApi.getLineValue(
      categories: widget.categories.value,
      timeType: widget.code.value,
    );
    setState(() {});
  }

  List<LineChartBarData> get lineBarsData {
    return rowValue.map((LineModel lineModel) {
      List<FlSpot> spots = lineModel.value.map((Value value) {
        return FlSpot(
          value.x.toDouble(),
          value.y.toDouble(),
        );
      }).toList();
      return LineChartBarData(
        color: AppColor.colors[lineModel.categoryID % AppColor.colors.length],
        barWidth: 3.h,
        spots: spots,
      );
    }).toList();
  }

  LineChartData get lineDate => LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: titlesData,
        borderData: FlBorderData(show: false),
        lineBarsData: lineBarsData,
        lineTouchData: lineTouchData,
        minY: 0,
        minX: rowValue.isNotEmpty ? rowValue.first.value.last.x.toDouble() : 0,
      );

  LineTouchData get lineTouchData {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (_) =>
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            if (touchedSpot.y == 0) return null;
            int i = touchedSpot.barIndex;
            String text =
                '${rowValue[i].categoryName}:${StringUtil.formatDuration(
              context,
              touchedSpot.y.toInt(),
            )}';
            return LineTooltipItem(
              text,
              TextStyle(
                color: touchedSpot.bar.color,
                fontSize: 12.sp,
              ),
            );
          }).toList();
        },
      ),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            interval: intervalX,
            showTitles: true,
            getTitlesWidget: bottomTitleWidgets,
            reservedSize: 30,
            minIncluded: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              interval: intervalY,
              reservedSize: reservedSizeY,
              getTitlesWidget: leftTitleWidgets,
              maxIncluded: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
    );
    double hour = value / 1000 / 60 / 60;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        hour.toStringAsFixed(0),
        style: style,
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
    );

    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    String formattedDate = formatX.format(date);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 12,
      fitInside: SideTitleFitInsideData(
        enabled: true,
        distanceFromEdge: 5.w,
        parentAxisSize: 0,
        axisPosition: 0,
      ),
      child: Text(
        formattedDate,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Padding(
        padding: EdgeInsets.only(right: 8.w),
        child: LineChart(
          lineDate,
          duration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }
}
