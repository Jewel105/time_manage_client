import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_manage_client/common/app_color.dart';

typedef FnCallBack = void Function();

class MainButton extends StatelessWidget {
  final String text;
  final String? preIcon;
  final Color? bgColor;
  final FnCallBack? onPressed;
  final double? height;
  final double? width;
  final bool rounded; // 是否圆角
  final Color? borderColor;
  final double? fontSize;
  final TextStyle? textStyle;
  const MainButton({
    super.key,
    required this.text,
    this.textStyle,
    this.preIcon,
    this.bgColor = AppColor.appMainColor,
    this.onPressed,
    this.height,
    this.width,
    this.rounded = false,
    this.borderColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 40.w,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          foregroundColor: bgColor,
          backgroundColor: bgColor,
          elevation: 0,
          shape: rounded
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.w),
                  side: BorderSide(color: borderColor ?? Colors.transparent),
                )
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.w),
                  side: BorderSide(color: borderColor ?? Colors.transparent)),
        ),
        onPressed: onPressed == null
            ? null
            : () {
                FocusManager.instance.primaryFocus?.unfocus();
                onPressed?.call();
              },
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                fontSize: fontSize ?? 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textDarkGreyColor,
              ),
        ),
      ),
    );
  }
}
