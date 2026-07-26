import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';
import '../utils/constants.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Fetch a single random quote
  Future<QuoteModel> fetchRandomQuote() async {
    try {
      final countryCode = ui.PlatformDispatcher.instance.locale.countryCode ?? '';
      final response = await _client.get(
        Uri.parse('${AppConstants.apiBaseUrl}/random?country=$countryCode'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return QuoteModel.fromJson(jsonResponse['data']);
        } else {
          throw Exception(jsonResponse['error'] ?? 'Failed to parse quote');
        }
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(errorResponse['error'] ?? 'Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Could not connect to server. Ensure backend is running. ($e)');
    }
  }

  // Fetch all quotes (for reference, admin features, or category display)
  Future<List<QuoteModel>> fetchAllQuotes({String? category}) async {
    try {
      String url = AppConstants.apiBaseUrl;
      if (category != null && category.isNotEmpty) {
        url += '?category=$category';
      }

      final response = await _client.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => QuoteModel.fromJson(json)).toList();
        } else {
          throw Exception(jsonResponse['error'] ?? 'Failed to parse quotes');
        }
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(errorResponse['error'] ?? 'Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Could not connect to server. Ensure backend is running. ($e)');
    }
  }
}
