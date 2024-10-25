class EnvConfig {
  final String envName;
  final String envHttpUrl;

  EnvConfig({
    required this.envName,
    required this.envHttpUrl,
  });
}

enum EnvType { development, production }

class Env {
  // 当前环境
  // 运行： flutter run --dart-define=APP_ENV=dev
  static const String _appEnv =
      String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  static EnvType get appEnv {
    switch (_appEnv) {
      case 'dev':
        return EnvType.development;
      case 'pro':
        return EnvType.production;
      default:
        return EnvType.development;
    }
  }

  // 当前环境配置
  static EnvConfig get envConfig => _getEnvConfig();
  static EnvConfig _getEnvConfig() {
    switch (_appEnv) {
      case 'pro':
        return _proConfig;
      default:
        return _devConfig;
    }
  }

  // 测试环境，http证书
  static final EnvConfig _devConfig = EnvConfig(
    envName: 'development',
    envHttpUrl: 'https://127.0.0.1:8081/api/v1',
  );

  // 生产环境，http2证书
  static final EnvConfig _proConfig = EnvConfig(
    envName: 'production',
    envHttpUrl: 'https://8.137.51.66:8081/api/v1',
  );
}
