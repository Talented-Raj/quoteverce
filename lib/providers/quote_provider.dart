import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class QuoteProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  QuoteModel? _currentQuote;
  bool _isLoading = false;
  String? _errorMessage;
  List<QuoteModel> _favorites = [];

  // Getters
  QuoteModel? get currentQuote => _currentQuote;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<QuoteModel> get favorites => _favorites;

  QuoteProvider() {
    _initializeData();
  }

  // Initialize cached quote and favorites lists
  Future<void> _initializeData() async {
    _isLoading = true;
    notifyListeners();

    // 1. Load favorites list from storage
    _favorites = await CacheService.getFavorites();

    // 2. Load last quote from storage as fallback
    final cachedQuote = await CacheService.getLastQuote();
    if (cachedQuote != null) {
      _currentQuote = cachedQuote;
      _isLoading = false;
      notifyListeners();
      
      // Fetch fresh random quote in background
      _fetchFreshQuoteInBackground();
    } else {
      // No cache, fetch from API immediately
      await loadRandomQuote();
    }
  }

  // Fetch from server in background silently (avoiding loader blocks)
  Future<void> _fetchFreshQuoteInBackground() async {
    try {
      final freshQuote = await _apiService.fetchRandomQuote();
      _currentQuote = freshQuote;
      _errorMessage = null;
      await CacheService.saveLastQuote(freshQuote);
    } catch (_) {
      // Fail silently since user is already seeing a cached quote
    } finally {
      notifyListeners();
    }
  }

  // Explicitly fetch random quote (triggered on launch or button tap)
  Future<void> loadRandomQuote() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final quote = await _apiService.fetchRandomQuote();
      _currentQuote = quote;
      await CacheService.saveLastQuote(quote);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      
      // If we have a cached quote, show that instead of a blank error screen
      if (_currentQuote == null) {
        final cached = await CacheService.getLastQuote();
        if (cached != null) {
          _currentQuote = cached;
          _errorMessage = null; // Suppress full-screen error since we have a backup
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check if a quote is in the favorites list
  bool isFavorite(QuoteModel quote) {
    return _favorites.any((item) => item.id == quote.id);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(QuoteModel quote) async {
    final index = _favorites.indexWhere((item) => item.id == quote.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(quote);
    }
    notifyListeners();
    await CacheService.saveFavorites(_favorites);
  }

  // Clear all error state
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
