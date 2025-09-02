import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/services/api_service.dart';
import 'package:habit_tracker/config/app_config.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _userName;
  String? _userId;
  String? _accessToken;
  String? _refreshToken;
  
  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get userId => _userId;
  String? get accessToken => _accessToken;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool(AppConfig.storageAuthKey) ?? false;
    _userEmail = prefs.getString(AppConfig.storageUserEmailKey);
    _userName = prefs.getString(AppConfig.storageUserNameKey);
    _userId = prefs.getString(AppConfig.storageUserIdKey);
    _accessToken = prefs.getString(AppConfig.storageAccessTokenKey);
    _refreshToken = prefs.getString(AppConfig.storageRefreshTokenKey);
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      // Try real API first
      final data = await ApiService.post(
        AppConfig.authLoginEndpoint,
        body: {
          'email_or_username': email,
          'password': password,
        },
      );
      
      // Extract user data and tokens
      _accessToken = data['access_token'];
      _refreshToken = data['refresh_token'];
      _isAuthenticated = true;
      _userEmail = data['user']['email'];
      _userName = data['user']['first_name'] ?? data['user']['username'];
      _userId = data['user']['id'];
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConfig.storageAuthKey, true);
      await prefs.setString(AppConfig.storageUserEmailKey, _userEmail!);
      await prefs.setString(AppConfig.storageUserNameKey, _userName!);
      await prefs.setString(AppConfig.storageUserIdKey, _userId!);
      await prefs.setString(AppConfig.storageAccessTokenKey, _accessToken!);
      await prefs.setString(AppConfig.storageRefreshTokenKey, _refreshToken!);
      
      notifyListeners();
      return true;
    } catch (e) {
      // Fallback to mock authentication if backend is not available
      if (AppConfig.enableMockAuth) {
        return _mockLogin(email, password);
      }
      rethrow;
    }
  }

  // Mock authentication for testing when backend is not available
  Future<bool> _mockLogin(String email, String password) async {
    // Simple mock validation
    if (email.isNotEmpty && password.length >= 6) {
      _isAuthenticated = true;
      _userEmail = email;
      _userName = email.split('@')[0];
      _userId = 'mock_user_${DateTime.now().millisecondsSinceEpoch}';
      _accessToken = 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
      _refreshToken = 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConfig.storageAuthKey, true);
      await prefs.setString(AppConfig.storageUserEmailKey, _userEmail!);
      await prefs.setString(AppConfig.storageUserNameKey, _userName!);
      await prefs.setString(AppConfig.storageUserIdKey, _userId!);
      await prefs.setString(AppConfig.storageAccessTokenKey, _accessToken!);
      await prefs.setString(AppConfig.storageRefreshTokenKey, _refreshToken!);
      
      notifyListeners();
      return true;
    }
    throw Exception('Invalid credentials');
  }

  Future<bool> register(String fullName, String email, String password) async {
    try {
      // Split full name into first and last name
      final nameParts = fullName.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      
      // Generate username from email
      final username = email.split('@')[0];
      
      await ApiService.post(
        AppConfig.authRegisterEndpoint,
        body: {
          'email': email,
          'username': username,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
        },
      );

      // Registration successful, now login
      return await login(email, password);
    } catch (e) {
      // Fallback to mock authentication if backend is not available
      if (AppConfig.enableMockAuth) {
        return _mockRegister(fullName, email, password);
      }
      rethrow;
    }
  }

  // Mock registration for testing when backend is not available
  Future<bool> _mockRegister(String fullName, String email, String password) async {
    // Simple mock validation
    if (fullName.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      // Simulate successful registration and login
      return await _mockLogin(email, password);
    }
    throw Exception('Invalid registration data');
  }

  Future<void> logout() async {
    try {
      // Call logout endpoint if we have a token
      if (_accessToken != null) {
        await ApiService.post(
          AppConfig.authLogoutEndpoint,
          accessToken: _accessToken,
        );
      }
    } catch (e) {
      // Ignore logout errors, continue with local cleanup
    }
    
    // Clear local state
    _isAuthenticated = false;
    _userEmail = null;
    _userName = null;
    _userId = null;
    _accessToken = null;
    _refreshToken = null;
    
    // Clear local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.storageAuthKey);
    await prefs.remove(AppConfig.storageUserEmailKey);
    await prefs.remove(AppConfig.storageUserNameKey);
    await prefs.remove(AppConfig.storageUserIdKey);
    await prefs.remove(AppConfig.storageAccessTokenKey);
    await prefs.remove(AppConfig.storageRefreshTokenKey);
    
    notifyListeners();
  }

  Future<void> updateProfile(String newName) async {
    if (newName.isNotEmpty && _accessToken != null) {
      try {
        await ApiService.put(
          AppConfig.authProfileEndpoint,
          body: {
            'first_name': newName,
          },
          accessToken: _accessToken,
        );

        _userName = newName;
        
        // Update local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConfig.storageUserNameKey, newName);
        
        notifyListeners();
      } catch (e) {
        // Handle profile update errors
        rethrow;
      }
    }
  }

  Future<bool> refreshToken() async {
    if (_refreshToken == null) return false;
    
    try {
      final data = await ApiService.post(
        AppConfig.authRefreshEndpoint,
        body: {
          'refresh_token': _refreshToken,
        },
      );
      
      // Update tokens
      _accessToken = data['access_token'];
      _refreshToken = data['refresh_token'];
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.storageAccessTokenKey, _accessToken!);
      await prefs.setString(AppConfig.storageRefreshTokenKey, _refreshToken!);
      
      notifyListeners();
      return true;
    } catch (e) {
      // Refresh failed, user needs to login again
      await logout();
    }
    
    return false;
  }

  // Helper method to get authenticated headers for API calls
  Map<String, String> getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
    };
  }

  // Test API connection
  Future<bool> testApiConnection() async {
    try {
      return await ApiService.testConnection();
    } catch (e) {
      return false;
    }
  }
}
