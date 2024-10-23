import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/common/app_color.dart';

class AppStyle {
  static final TextStyle h1 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColor.textBlackColor,
  );
  static final TextStyle h2 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle h3 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle body = TextStyle(
    fontSize: 14.sp,
    color: AppColor.textBlackColor,
  );
  static final TextStyle tip = TextStyle(
    fontSize: 14.sp,
    color: AppColor.textGreyColor,
  );
}
