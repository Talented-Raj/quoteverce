import 'package:flutter/material.dart';
import '../services/cache_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadThemeFromCache();
  }

  // Load configuration from local SharedPreferences
  Future<void> _loadThemeFromCache() async {
    final cachedVal = await CacheService.getThemeMode();
    if (cachedVal != null) {
      _isDarkMode = cachedVal;
      notifyListeners();
    }
  }

  // Toggle Dark/Light Mode state
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await CacheService.saveThemeMode(_isDarkMode);
  }
}
