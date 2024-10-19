import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static late SharedPreferencesWithCache _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        // When an allowlist is included, any keys that aren't included cannot be used.
        allowList: <String>{'repeat', 'action'},
      ),
    );
  }

  // 设置本地缓存
  static Future<void> set<T>(String key, T value) {
    if (T == String) {
      return _preferences.setString(key, value as String);
    } else if (T == int) {
      return _preferences.setInt(key, value as int);
    } else if (T == bool) {
      return _preferences.setBool(key, value as bool);
    } else if (T == double) {
      return _preferences.setDouble(key, value as double);
    } else if (T == List<String>) {
      return _preferences.setStringList(key, value as List<String>);
    } else if (T == Map<String, dynamic>) {
      return _preferences.setString(key, json.encode(value));
    } else {
      return Future<void>.value();
    }
  }

  // 取出缓存
  static dynamic get(String key) {
    dynamic value = _preferences.get(key);
    if (value.runtimeType.toString() == 'String') {
      try {
        return json.decode(value as String);
      } catch (err) {
        return value;
      }
    }
    return value;
  }

  // 删除缓存
  static Future<void> remove(String key) {
    return _preferences.remove(key);
  }
}
