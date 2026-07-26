import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote_model.dart';
import '../utils/constants.dart';

class CacheService {
  // Save last quote for offline launch fallback
  static Future<void> saveLastQuote(QuoteModel quote) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyLastQuote, json.encode(quote.toJson()));
  }

  // Get last quote cached
  static Future<QuoteModel?> getLastQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppConstants.keyLastQuote);
    if (data == null) return null;
    try {
      return QuoteModel.fromJson(json.decode(data) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  // Save the complete favorites list
  static Future<void> saveFavorites(List<QuoteModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> dataList = favorites
        .map((quote) => json.encode(quote.toJson()))
        .toList();
    await prefs.setStringList(AppConstants.keyFavorites, dataList);
  }

  // Retrieve favorites list
  static Future<List<QuoteModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? dataList = prefs.getStringList(AppConstants.keyFavorites);
    if (dataList == null) return [];
    
    return dataList.map((item) {
      try {
        return QuoteModel.fromJson(json.decode(item) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<QuoteModel>().toList();
  }

  // Save Theme Preferences
  static Future<void> saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyDarkMode, isDarkMode);
  }

  // Read Theme Preferences
  static Future<bool?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.keyDarkMode);
  }
}
