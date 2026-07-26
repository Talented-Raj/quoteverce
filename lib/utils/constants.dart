import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = 'Quote Duniya';
  
  // Replace this with your actual deployed Vercel/Render URL when deployed
  static const String productionApiUrl = 'https://quoteverse-backend.vercel.app/quotes';

  static String get apiBaseUrl {
    if (kIsWeb) {
      final host = Uri.base.host;
      if (host.contains('localhost') || host.contains('127.0.0.1')) {
        return 'http://localhost:5000/quotes';
      }
      return productionApiUrl;
    } else {
      // For mobile app builds, you can change this to productionApiUrl for remote fetching
      // or keep it pointing to localhost emulator for local tests
      return 'http://10.0.2.2:5000/quotes';
    }
  }

  // SharedPreferences Keys
  static const String keyFavorites = 'quote_duniya_favorites';
  static const String keyLastQuote = 'quote_duniya_last_quote';
  static const String keyDarkMode = 'quote_duniya_dark_mode';
}
