import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/common/app_color.dart';
import 'package:time_manage_client/common/app_style.dart';

final ThemeData appLightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: AppColor.mainDarkColor,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: AppColor.mainDarkColor,
  ),
  highlightColor: Colors.transparent,
  textTheme: TextTheme(
    bodyMedium: TextStyle(fontSize: 14.sp),
  ),
  scaffoldBackgroundColor: AppColor.bgWhiteColor,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColor.bgWhiteColor, // 设置 AppBar 的背景色
    surfaceTintColor: AppColor.bgWhiteColor,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.textBlackColor,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColor.bgWhiteColor,
    unselectedItemColor: AppColor.textLightGreyColor,
    selectedItemColor: AppColor.mainDarkColor,
    selectedLabelStyle: AppStyle.h3,
    unselectedLabelStyle: AppStyle.h3,
    type: BottomNavigationBarType.fixed,
    elevation: 10,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColor.bgWhiteColor,
    isCollapsed: true,
    contentPadding: EdgeInsets.all(12.sp),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.lineColor),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.mainDarkColor),
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.lineColor),
    ),
    hintStyle: const TextStyle(
      color: AppColor.textLightGreyColor,
    ),
    errorStyle: const TextStyle(
      color: AppColor.textErrorDarkColor,
    ),
  ),
);

final ThemeData appDarkTheme = ThemeData(
  useMaterial3: true,
  primaryColor: AppColor.mainLightColor,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: AppColor.mainLightColor,
  ),
  highlightColor: Colors.transparent,
  textTheme: TextTheme(
    bodyMedium: TextStyle(fontSize: 14.sp),
  ),
  scaffoldBackgroundColor: AppColor.bgBlackColor,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColor.bgBlackColor, // 设置 AppBar 的背景色
    surfaceTintColor: AppColor.bgBlackColor,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.mainLightColor,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColor.bgBlackColor,
    unselectedItemColor: AppColor.textLightGreyColor,
    selectedItemColor: AppColor.mainLightColor,
    selectedLabelStyle: AppStyle.h3,
    unselectedLabelStyle: AppStyle.h3,
    type: BottomNavigationBarType.fixed,
    elevation: 10,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColor.bgBlackColor,
    isCollapsed: true,
    contentPadding: EdgeInsets.all(12.sp),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.lineColor),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.mainLightColor),
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.lineColor),
    ),
    hintStyle: const TextStyle(
      color: AppColor.textLightGreyColor,
    ),
    errorStyle: const TextStyle(
      color: AppColor.textErrorLightColor,
    ),
  ),
);
