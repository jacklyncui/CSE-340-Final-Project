import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';

// Part of the code comes from https://github.com/GAM3RG33K/flutter_settings_screens/blob/master/example/lib/cache_provider.dart

class CachedSettingsProvider extends CacheProvider {
  final Box? _preferences;

  CachedSettingsProvider(this._preferences);

  @override
  bool containsKey(String key) {
    return _preferences?.containsKey(key) ?? false;
  }

  @override
  bool? getBool(String key, {bool? defaultValue}) {
    return _preferences?.get(key);
  }

  @override
  double? getDouble(String key, {double? defaultValue}) {
    return _preferences?.get(key);
  }

  @override
  int? getInt(String key, {int? defaultValue}) {
    return _preferences?.get(key);
  }

  @override
  Set getKeys() {
    return _preferences?.keys.toSet() ?? {};
  }

  @override
  String? getString(String key, {String? defaultValue}) {
    return _preferences?.get(key);
  }

  @override
  T? getValue<T>(String key, {T? defaultValue}) {
    var value = _preferences?.get(key);
    if (value is T) {
      return value;
    }
    return defaultValue;
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> remove(String key) async {
    if (containsKey(key)) {
      await _preferences?.delete(key);
    }
  }

  @override
  Future<void> removeAll() async {
    final keys = getKeys();
    await _preferences?.deleteAll(keys);
  }

  @override
  Future<void> setBool(String key, bool? value) async {
    await _preferences?.put(key, value);
  }

  @override
  Future<void> setDouble(String key, double? value) async {
    await _preferences?.put(key, value);
  }

  @override
  Future<void> setInt(String key, int? value) async {
    await _preferences?.put(key, value);
  }

  @override
  Future<void> setString(String key, String? value) async {
    await _preferences?.put(key, value);
  }

  @override
  Future<void> setObject<T>(String key, T? value) async {
    await _preferences?.put(key, value);
  }
}
