import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:time_manage_client/http/base_entity.dart';
import 'package:time_manage_client/http/dio_interceptors.dart';
import 'package:time_manage_client/http/env.dart';
import 'package:time_manage_client/utils/dialog_util.dart';

// 请求方法
enum DioMethod { get, post, put, delete, patch, head }

/// 使用拓展枚举替代 switch判断取值
/// https://zhuanlan.zhihu.com/p/98545689
extension MethodExtension on DioMethod {
  String get value =>
      <String>['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}

class DioUtil {
  // 连接超时时间
  static const Duration _connectTime = Duration(seconds: 60);
  // 响应超时时间，他们接口有时候很慢，时间搞长一点
  static const Duration _receiveTime = Duration(seconds: 60);
  // 请求url前缀
  static final String _baseUrl = Env.envConfig.envHttpUrl;

  // 运行访问的证书sha256
  List<String> allowedSHAFingerprints = <String>[
    'c30c75dd28c3d0174d3f2eb6367a34138ab95f8fb69df8c956dac0969c618c42',
  ];

  // 单例模式
  static DioUtil? _instance;
  factory DioUtil() => _instance ?? DioUtil._internal();

  late Dio _dio;
  Dio get dio => _dio;

  DioUtil._internal() {
    _instance = this;
    _instance!._init();
  }

  _init() {
    // 初始化基本选项
    BaseOptions options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _connectTime,
      receiveTimeout: _receiveTime,
    );

    // 初始化dio
    _dio = Dio(options);

    // release模式
    if (kReleaseMode) {
      // 配置http2证书
      _dio.httpClientAdapter = Http2Adapter(
        ConnectionManager(
            idleTimeout: _receiveTime,
            onClientCreate: (_, ClientSetting config) {
              config.onBadCertificate = (X509Certificate cert) {
                String serverCertSha256 = getCertSHA256Fingerprint(cert);
                if (allowedSHAFingerprints.contains(serverCertSha256)) {
                  return true;
                } else {
                  return false;
                }
              };
            }),
      );
    } else {
      // 调试,http2无法抓到包
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final HttpClient client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            String serverCertSha256 = getCertSHA256Fingerprint(cert);
            if (allowedSHAFingerprints.contains(serverCertSha256)) {
              return true;
            } else {
              return false;
            }
          };
          return client;
        },
      );
    }

    // 添加拦截
    _dio.interceptors.add(DioInterceptors());
  }

  /// 取消请求token
  final CancelToken _cancelToken = CancelToken();

  // 发送请求方法
  Future<T> request<T>(String path,
      {DioMethod method = DioMethod.get,
      Map<String, dynamic>? params,
      Object? data,
      CancelToken? cancelToken,
      Options? options,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      bool loading = false}) async {
    // 将请求方法组合到options中
    options ??= Options();
    options.method = method.value;

    CancelFunc? cancel;
    if (loading) {
      // 自定义loading
      cancel = DialogUtil.showLoading();
    }

    try {
      // 调用dio的请求方法
      Response<T> response;
      response = await _dio.request<T>(path,
          data: data,
          queryParameters: params,
          cancelToken: cancelToken ?? _cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      if (loading && cancel != null) {
        cancel();
      }
      return BaseEntity<dynamic>.fromJson(response.data as Map<String, dynamic>)
          .data;
    } on DioException catch (_) {
      rethrow;
    } finally {
      if (loading && cancel != null) {
        cancel(); // 无论成功还是抛异常，都执行
      }
    }
  }

  // 取消请求方法
  void cancelRequests() {
    _cancelToken.cancel('cancel');
  }

  // get请求
  Future<T?> get<T>(
          {required String url,
          Map<String, dynamic>? params,
          CancelToken? cancelToken,
          Options? options,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress,
          bool loading = false}) =>
      request(url,
          method: DioMethod.get,
          params: params,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          loading: loading);

  // POST 请求
  Future<T?> post<T>(
          {required String url,
          Object? data,
          CancelToken? cancelToken,
          Options? options,
          ProgressCallback? onSendProgress,
          ProgressCallback? onReceiveProgress,
          bool loading = false}) =>
      request(url,
          method: DioMethod.post,
          data: data,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          loading: loading);

  // 获得证书的 SHA-256 指纹
  String getCertSHA256Fingerprint(X509Certificate cert) {
    try {
      // 移除 PEM 编码的头尾标识和换行符
      final String derBase64 = cert.pem
          .replaceAll(RegExp(r'-----(BEGIN|END) CERTIFICATE-----'), '')
          .replaceAll(RegExp(r'\s+'), '');

      // 将清理后的 Base64 字符串解码为字节数组
      final Uint8List derBytes = base64Decode(derBase64);

      // 计算 SHA-256 指纹
      final Digest digest = sha256.convert(derBytes);
      return digest.toString();
    } catch (e) {
      return 'Failed to get certificate SHA-256 fingerprint';
    }
  }
}
