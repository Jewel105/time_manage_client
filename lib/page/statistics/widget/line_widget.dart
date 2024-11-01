import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:time_manage_client/api/statistic_api.dart';
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
  List<Color> colors = <Color>[
    const Color(0xffA2D2FF),
    const Color(0xffBDE0FE),
    const Color(0xffFFC8DD),
    const Color(0xffFFAFCC),
    const Color(0xffCDB4DB),
    const Color(0xffD4A5A5),
  ];

  @override
  void initState() {
    super.initState();
    _updateLineData();
  }

  void _updateLineData() async {
    rowValue = await StatisticApi.getLineValue(
      categories: widget.categories.value,
      timeType: widget.code.value,
    );
    setState(() {});
  }

  @override
  void didUpdateWidget(LineWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateLineData();
  }

  List<LineChartBarData> get lineBarsData {
    return rowValue.map((LineModel lineModel) {
      int index = rowValue.indexOf(lineModel);
      List<FlSpot> spots = lineModel.value
          .map(
            (Value value) => FlSpot(
              value.x.toDouble(),
              value.y.toDouble(),
            ),
          )
          .toList();
      return LineChartBarData(
        color: colors[index % colors.length],
        barWidth: 3.h,
        spots: spots,
      );
    }).toList();
  }

  LineChartData get lineDate => LineChartData(
        titlesData: titlesData,
        borderData: FlBorderData(show: false),
        lineBarsData: lineBarsData,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                int i = touchedSpot.barIndex;
                String text =
                    '${rowValue[i].categoryName}-${StringUtil.formatDuration(
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
        ),
        minY: 0,
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitleWidgets,
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: leftTitleWidgets,
          ),
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
      fontWeight: FontWeight.bold,
      fontSize: 12.sp,
    );
    double hour = value / 1000 / 60 / 60;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        hour.toStringAsFixed(1),
        style: style,
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12.sp,
    );

    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    String formattedDate = DateFormat('d').format(date);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(
        formattedDate,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        lineDate,
        duration: const Duration(milliseconds: 250),
      ),
    );
  }
}
