import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/common/app_color.dart';
import 'package:time_manage_client/common/app_style.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColor.appMainColor,
  highlightColor: Colors.transparent,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColor.appMainColor,
    onPrimary: AppColor.textBlackColor,
    secondary: AppColor.appMainColor,
    onSecondary: AppColor.textBlackColor,
    error: AppColor.bgError,
    onError: AppColor.textErrorColor,
    surface: AppColor.bgGreyColor,
    onSurface: AppColor.textGreyColor,
  ),
  textTheme: TextTheme(bodyMedium: AppStyle.body),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColor.bgWhiteColor,
    surfaceTintColor: AppColor.bgWhiteColor,
    centerTitle: true,
    titleTextStyle: AppStyle.h1,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    unselectedItemColor: AppColor.textLightGreyColor,
    selectedItemColor: AppColor.appMainColor,
    selectedLabelStyle: AppStyle.h3,
    unselectedLabelStyle: AppStyle.h3,
    type: BottomNavigationBarType.fixed,
    elevation: 10,
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
