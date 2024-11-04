import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:time_manage_client/common/app_color.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/utils/index.dart';
import 'package:time_manage_client/widget/main_button.dart';

typedef CancelFunc = void Function();

class DialogUtil {
  // 提示框
  static Future<void> openDialog({
    String content = '--',
    String? confirmText,
    String? cancelText,
    String? titleText,
    String? icon,
  }) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            borderRadius: BorderRadius.circular(8.w),
            child: Container(
              width: 300.w,
              padding: EdgeInsets.symmetric(vertical: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text(
                            titleText ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 16.w,
                          child: GestureDetector(
                            onTap: () {
                              NavCtrl.back(arguments: false);
                            },
                            child: Icon(
                              Icons.close,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.w),
                    Icon(Icons.mark_chat_unread_outlined, size: 48.w),
                    SizedBox(height: 12.w),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28.w),
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 16 / 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 18.w),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: <Widget>[
                          Visibility(
                            visible: cancelText != null,
                            child: Expanded(
                              child: MainButton(
                                text: cancelText ?? 'Cancel',
                                onPressed: () {
                                  NavCtrl.back(arguments: false);
                                },
                              ),
                            ),
                          ),
                          Visibility(
                              visible: cancelText != null,
                              child: SizedBox(width: 8.w)),
                          Expanded(
                            child: MainButton(
                              text: confirmText ?? context.locale.confirm,
                              onPressed: () {
                                NavCtrl.back(arguments: true);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }

  // loading
  static CancelFunc showLoading() {
    return BotToast.showCustomLoading(
      backgroundColor: AppColor.bgMask,
      toastBuilder: (CancelFunc cancel) {
        return SpinKitSpinningLines(
          color: AppColor.mainDarkColor,
          lineWidth: 8.w,
          itemCount: 3,
        );
      },
    );
  }

  static closeAllLoading() {
    BotToast.closeAllLoading();
  }
}
