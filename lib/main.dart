import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:time_manage_client/api/common_api.dart';
import 'package:time_manage_client/common/app_theme.dart';
import 'package:time_manage_client/common/constant.dart';
import 'package:time_manage_client/router/create_routes.dart';
import 'package:time_manage_client/router/nav_ctrl.dart';
import 'package:time_manage_client/utils/storage_util.dart';

void main() {
  // 拦截flutter异常,同步异常
  FlutterExceptionHandler? onError = FlutterError.onError; //先将 onerror 保存起来
  FlutterError.onError = (FlutterErrorDetails details) {
    onError?.call(details); //调用默认的onError
    _reportError(
        details.exception.toString(), details.stack.toString()); // 上报异常
  };

  // 拦截未处理的异步错误
  ZoneSpecification zoneSpecification = ZoneSpecification(
    handleUncaughtError: (Zone self, ZoneDelegate parent, Zone zone,
        Object error, StackTrace stackTrace) {
      if (error is DioException) return; // 网络异常不上报
      if (error is DioH2NotSupportedException) return; // 网络异常不上报
      _reportError(error.toString(), stackTrace.toString()); // 上报异常
    },
  );

  Zone.current.fork(specification: zoneSpecification).run(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await StorageUtil.init();
    _getDeviceId();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // 设计稿尺寸
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: MaterialApp(
            title: 'Time Manager',
            theme: appTheme,
            onGenerateRoute: CreateRoutes.generateRoute,
            navigatorKey: navigatorKey,
            localizationsDelegates: const <LocalizationsDelegate<Object?>>[
              ...AppLocalizations.localizationsDelegates,
              FormBuilderLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            builder: BotToastInit(),
            navigatorObservers: <NavigatorObserver>[
              BotToastNavigatorObserver()
            ],
          ),
        );
      },
    );
  }
}

// 获取设备ID
Future<void> _getDeviceId() async {
  int? equipmentId = StorageUtil.get(Constant.EQUIPMENTID) as int?;
  if (equipmentId != null) return;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> data = <String, dynamic>{};
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    data['vender'] = androidInfo.brand;
    data['type'] = androidInfo.id;
    data['sn'] = androidInfo.fingerprint;
    data['imei0'] = androidInfo.host;
    data['imei1'] = androidInfo.product;
    data['os'] = androidInfo.display;
    data['isPhysicalDevice'] = androidInfo.isPhysicalDevice ? 1 : 0;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    data['vender'] = iosInfo.model;
    data['type'] = iosInfo.name;
    data['sn'] = iosInfo.identifierForVendor ?? '-';
    data['imei0'] = iosInfo.utsname.nodename;
    data['imei1'] = iosInfo.systemVersion;
    data['os'] = iosInfo.systemName;
    data['isPhysicalDevice'] = iosInfo.isPhysicalDevice ? 1 : 0;
  }
  equipmentId = await CommonApi.registerDevice(data);
  await StorageUtil.set(Constant.EQUIPMENTID, equipmentId);
}

// 上报异常
void _reportError(String error, String stack) async {
  debugPrint(error);
  debugPrint(stack);
  if (!kReleaseMode) return;
  debugPrint('上报异常');
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  CommonApi.reportException(error, stack, version);
}
