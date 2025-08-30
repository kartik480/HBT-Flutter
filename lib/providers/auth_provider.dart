import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _userName;
  String? _userId;
  
  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get userId => _userId;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userEmail = prefs.getString('userEmail');
    _userName = prefs.getString('userName');
    _userId = prefs.getString('userId') ?? _userEmail ?? 'default_user';
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, accept any valid email/password
      if (email.isNotEmpty && password.isNotEmpty) {
        _isAuthenticated = true;
        _userEmail = email;
        _userName = email.split('@')[0]; // Use email prefix as username
        _userId = email; // Use email as userId
        
        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('userEmail', email);
        await prefs.setString('userName', _userName!);
        await prefs.setString('userId', email);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String fullName, String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, accept any valid registration
      if (fullName.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        _isAuthenticated = true;
        _userEmail = email;
        _userName = fullName.split(' ').first;
        _userId = email; // Use email as userId
        
        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('userEmail', email);
        await prefs.setString('userId', email);
        await prefs.setString('userName', _userName!);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userEmail = null;
    _userName = null;
    _userId = null;
    
    // Clear local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAuthenticated');
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('userId');
    
    notifyListeners();
  }

  Future<void> updateProfile(String newName) async {
    if (newName.isNotEmpty) {
      _userName = newName;
      
      // Update local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', newName);
      
      notifyListeners();
    }
  }
}
