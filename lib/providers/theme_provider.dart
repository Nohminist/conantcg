// theme_mode_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/common_utils.dart';


class ThemeModeProvider extends ChangeNotifier {
  // デフォルトではダークモードを使用
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeModeProvider() {
    loadThemeMode();
  }
  

  // 現在のテーマモードを取得するgetter
  ThemeMode get themeMode => _themeMode;

  // ダークモードが有効かどうかを取得するgetter
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // テーマモードを切り替えるメソッド
  void toggleMode() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }

    saveThemeMode(); // テーマモードを保存
    notifyListeners(); // 状態が変更されたことを通知
  }

  // テーマモードをローカルストレージに保存するメソッド
  Future<void> saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(getStorageKey('isDarkMode'), isDarkMode);
  }

  // ローカルストレージからテーマモードを読み込むメソッド
  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getBool(getStorageKey('isDarkMode')) ?? true ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // 状態が変更されたことを通知
  }
}

