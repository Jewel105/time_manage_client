import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TipsWidget extends StatelessWidget {
  const TipsWidget({super.key, required this.icon, required this.tip});

  final Widget icon;
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        icon,
        SizedBox(height: 8.w),
        Text(tip),
      ],
    ));
  }
}
