# 🔐 **Authentication System Guide**

## 🎯 **Overview**

Your Habit Tracker API includes a complete authentication system with JWT tokens, password hashing, and user management. This guide explains how to use all the authentication endpoints.

## 🚀 **Available Endpoints**

### **1. User Registration**
```http
POST /api/v1/auth/register
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "username": "username",
  "password": "password123",
  "first_name": "John",
  "last_name": "Doe"
}
```

**Response:**
```json
{
  "id": "user-uuid",
  "email": "user@example.com",
  "username": "username",
  "first_name": "John",
  "last_name": "Doe",
  "is_active": true,
  "is_verified": false,
  "created_at": "2025-01-01T00:00:00Z"
}
```

### **2. User Login**
```http
POST /api/v1/auth/login
```

**Request Body:**
```json
{
  "email_or_username": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "token_type": "bearer",
  "user": {
    "id": "user-uuid",
    "email": "user@example.com",
    "username": "username",
    "first_name": "John",
    "last_name": "Doe",
    "is_active": true,
    "is_verified": false,
    "created_at": "2025-01-01T00:00:00Z"
  }
}
```

### **3. Token Refresh**
```http
POST /api/v1/auth/refresh
```

**Request Body:**
```json
{
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

**Response:** Same as login response with new tokens

### **4. Get Current User Profile**
```http
GET /api/v1/auth/me
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response:** User profile data

### **5. Change Password**
```http
POST /api/v1/auth/change-password
```

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "current_password": "oldpassword123",
  "new_password": "newpassword123"
}
```

### **6. Forgot Password**
```http
POST /api/v1/auth/forgot-password
```

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

### **7. Reset Password**
```http
POST /api/v1/auth/reset-password
```

**Request Body:**
```json
{
  "reset_token": "reset-token-here",
  "new_password": "newpassword123"
}
```

### **8. Logout**
```http
POST /api/v1/auth/logout
```

**Note:** Client should discard tokens locally

## 🔒 **Security Features**

### **Password Hashing**
- Passwords are hashed using bcrypt
- Never stored in plain text
- Secure password verification

### **JWT Tokens**
- **Access Token**: Short-lived (30 minutes by default)
- **Refresh Token**: Long-lived (7 days by default)
- Secure token generation and verification
- Automatic token expiration

### **CORS Protection**
- Configured for your domain: `https://pznstudio.shop`
- Secure cross-origin requests
- Proper headers for security

## 📱 **Flutter Integration**

### **1. Store Tokens Securely**
```dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }
  
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }
}
```

### **2. API Calls with Authentication**
```dart
class ApiService {
  static const String baseUrl = 'https://pznstudio.shop/api';
  
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await AuthService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email_or_username': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await AuthService.saveTokens(
        data['access_token'],
        data['refresh_token'],
      );
      return data;
    } else {
      throw Exception('Login failed');
    }
  }
}
```

### **3. Automatic Token Refresh**
```dart
class TokenInterceptor extends Interceptor {
  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      try {
        final newToken = await refreshToken();
        // Retry original request with new token
        // Implementation depends on your HTTP client
      } catch (e) {
        // Refresh failed, redirect to login
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
    handler.next(err);
  }
}
```

## 🧪 **Testing Your Authentication**

### **1. Test Registration**
```bash
curl -X POST "https://pznstudio.shop/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser",
    "password": "password123",
    "first_name": "Test",
    "last_name": "User"
  }'
```

### **2. Test Login**
```bash
curl -X POST "https://pznstudio.shop/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email_or_username": "test@example.com",
    "password": "password123"
  }'
```

### **3. Test Protected Endpoint**
```bash
curl -X GET "https://pznstudio.shop/api/v1/auth/me" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## 🚨 **Common Issues & Solutions**

### **Token Expired (401)**
- Use refresh token to get new access token
- Implement automatic token refresh in your app

### **Invalid Credentials (401)**
- Check email/username and password
- Ensure user account is active

### **Email Already Registered (400)**
- Use different email address
- Check if user already exists

### **Username Already Taken (400)**
- Choose different username
- Usernames must be unique

## 🔧 **Configuration**

### **Environment Variables**
```bash
# Token expiration times
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# JWT settings
SECRET_KEY=your-secret-key
ALGORITHM=HS256
```

### **CORS Settings**
```python
ALLOWED_ORIGINS=https://pznstudio.shop,https://www.pznstudio.shop
```

## 📊 **Database Schema**

### **Users Table**
```sql
CREATE TABLE users (
    id VARCHAR PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    last_login TIMESTAMP
);
```

## 🎉 **What You Get**

✅ **Complete authentication system** - Register, login, logout  
✅ **JWT token management** - Access and refresh tokens  
✅ **Password security** - Bcrypt hashing  
✅ **User profile management** - Get and update user info  
✅ **Password reset functionality** - Forgot password flow  
✅ **CORS protection** - Secure cross-origin requests  
✅ **Production ready** - Optimized for Hostinger  

---

**Your authentication backend is ready to use! 🚀**

**Test it at: https://pznstudio.shop/api/docs**
