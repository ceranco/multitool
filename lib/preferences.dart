import 'package:flutter/widgets.dart';
import 'package:multitool/exceptions/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences._();

  static bool _initialized = false;
  static SharedPreferences _preferences;
  static final notifier = _Notifier();

  static bool _devMode;
  static bool get devMode => _devMode;
  static set devMode(bool value) {
    _devMode = value;
    _preferences.setBool('devMode', value);
    notifier.notify();
  }

  static void initialize(SharedPreferences preferences) {
    if (_initialized) {
      throw InvalidOperationException(
        'Preferences can only be initialized once',
      );
    }
    _initialized = true;
    _preferences = preferences;
    _devMode = _preferences.getBool('devMode') ?? false;
  }

  static void addListener(listener) => notifier.addListener(listener);

  static void removeListener(listener) => notifier.removeListener(listener);
}

class _Notifier extends ChangeNotifier {
  void notify() => notifyListeners();
}
