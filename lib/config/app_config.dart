class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'https://pznstudio.shop/api/v1';
  static const String apiHealthEndpoint = '/health';
  
  // Authentication endpoints
  static const String authLoginEndpoint = '/auth/login';
  static const String authRegisterEndpoint = '/auth/register';
  static const String authRefreshEndpoint = '/auth/refresh';
  static const String authLogoutEndpoint = '/auth/logout';
  static const String authProfileEndpoint = '/auth/profile';
  static const String authMeEndpoint = '/auth/me';
  
  // App Configuration
  static const String appName = 'Habit Tracker';
  static const String appVersion = '1.0.0';
  
  // Timeout Configuration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);
  
  // Local Storage Keys
  static const String storageAuthKey = 'isAuthenticated';
  static const String storageUserEmailKey = 'userEmail';
  static const String storageUserNameKey = 'userName';
  static const String storageUserIdKey = 'userId';
  static const String storageAccessTokenKey = 'accessToken';
  static const String storageRefreshTokenKey = 'refreshToken';
  
  // Validation Rules
  static const int minPasswordLength = 6;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;
  
  // Error Messages
  static const String errorNoInternet = 'No internet connection';
  static const String errorTimeout = 'Request timeout';
  static const String errorServerError = 'Server error. Please try again later.';
  static const String errorInvalidCredentials = 'Invalid email or password';
  static const String errorEmailAlreadyRegistered = 'Email already registered';
  static const String errorUsernameAlreadyTaken = 'Username already taken';
  
  // Success Messages
  static const String successLogin = 'Login successful';
  static const String successRegister = 'Registration successful';
  static const String successLogout = 'Logout successful';
  static const String successProfileUpdate = 'Profile updated successfully';
  
  // Development Mode
  static const bool isDevelopment = false;
  
  // Mock Authentication (fallback when backend is not available)
  static const bool enableMockAuth = true;
  
  // Debug Configuration
  static const bool enableApiLogging = false;
  static const bool enableErrorLogging = true;
}
