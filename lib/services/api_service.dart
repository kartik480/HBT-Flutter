import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:habit_tracker/config/app_config.dart';

class ApiService {
  // HTTP client with timeout
  static final http.Client _client = http.Client();
  
  // Default headers
  static Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Get authenticated headers
  static Map<String, String> getAuthHeaders(String? accessToken) {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  // Generic GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? accessToken,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}$endpoint').replace(queryParameters: queryParams);
      final response = await _client
          .get(uri, headers: getAuthHeaders(accessToken))
          .timeout(AppConfig.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? accessToken,
  }) async {
    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      final response = await _client
          .post(
            uri,
            headers: getAuthHeaders(accessToken),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConfig.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? accessToken,
  }) async {
    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      final response = await _client
          .put(
            uri,
            headers: getAuthHeaders(accessToken),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConfig.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? accessToken,
  }) async {
    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}$endpoint');
      final response = await _client
          .delete(uri, headers: getAuthHeaders(accessToken))
          .timeout(AppConfig.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Handle HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success response
      if (response.body.isEmpty) {
        return {'message': 'Success'};
      }
      return jsonDecode(response.body);
    } else {
      // Error response
      String errorMessage = 'Request failed';
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['detail'] ?? errorData['message'] ?? errorMessage;
      } catch (e) {
        // If we can't parse the error, use status code
        switch (response.statusCode) {
          case 400:
            errorMessage = 'Bad request';
            break;
          case 401:
            errorMessage = AppConfig.errorInvalidCredentials;
            break;
          case 403:
            errorMessage = 'Forbidden';
            break;
          case 404:
            errorMessage = 'Not found';
            break;
          case 422:
            errorMessage = 'Validation error';
            break;
          case 500:
            errorMessage = AppConfig.errorServerError;
            break;
          case 502:
            errorMessage = 'Bad gateway';
            break;
          case 503:
            errorMessage = 'Service unavailable';
            break;
          default:
            errorMessage = 'Request failed with status: ${response.statusCode}';
        }
      }
      throw ApiException(errorMessage, response.statusCode);
    }
  }

  // Handle network errors
  static Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }
    
    if (error.toString().contains('SocketException')) {
      return ApiException(AppConfig.errorNoInternet, 0);
    }
    
    if (error.toString().contains('TimeoutException')) {
      return ApiException(AppConfig.errorTimeout, 0);
    }
    
    return ApiException('Network error: ${error.toString()}', 0);
  }

  // Test API connectivity
  static Future<bool> testConnection() async {
    try {
      final response = await _client
          .get(Uri.parse('${AppConfig.apiBaseUrl}${AppConfig.apiHealthEndpoint}'))
          .timeout(AppConfig.connectionTimeout);
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Log API requests (for debugging)
  static void _logRequest(String method, String endpoint, {Map<String, dynamic>? body}) {
    if (AppConfig.enableApiLogging) {
      print('🌐 API Request: $method $endpoint');
      if (body != null) {
        print('📦 Body: ${jsonEncode(body)}');
      }
    }
  }

  // Log API responses (for debugging)
  static void _logResponse(String method, String endpoint, int statusCode, {String? body}) {
    if (AppConfig.enableApiLogging) {
      print('✅ API Response: $method $endpoint -> $statusCode');
      if (body != null && body.isNotEmpty) {
        print('📥 Response: $body');
      }
    }
  }
}

// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
