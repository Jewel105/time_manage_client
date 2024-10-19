import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/common/app_color.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColor.appMainColor,
  highlightColor: Colors.transparent,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColor.bgWhiteColor,
    surfaceTintColor: AppColor.bgWhiteColor,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.textDarkGreyColor,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    unselectedItemColor: AppColor.textLightGreyColor,
    selectedItemColor: AppColor.appMainColor,
    selectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    unselectedLabelStyle:
        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    type: BottomNavigationBarType.fixed,
    elevation: 10,
  ),
  colorScheme: ColorScheme.fromSeed(
    primary: AppColor.appMainColor,
    seedColor: AppColor.appMainColor,
    surface: AppColor.bgWhiteColor,
  ),
  scaffoldBackgroundColor: AppColor.bgWhiteColor,
  useMaterial3: true,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColor.bgWhiteColor,
    isCollapsed: true,
    contentPadding: EdgeInsets.all(12.sp),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.lineColor),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.appMainColor),
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.lineColor),
    ),
    hintStyle: const TextStyle(
      color: AppColor.textLightGreyColor,
    ),
    errorStyle: const TextStyle(
      color: AppColor.textErrorColor,
    ),
  ),
);
