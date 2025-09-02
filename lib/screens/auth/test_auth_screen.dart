import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:habit_tracker/services/api_service.dart';
import 'package:habit_tracker/config/app_config.dart';
import 'package:habit_tracker/utils/app_theme.dart';

class TestAuthScreen extends StatefulWidget {
  const TestAuthScreen({super.key});

  @override
  State<TestAuthScreen> createState() => _TestAuthScreenState();
}

class _TestAuthScreenState extends State<TestAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  
  bool _isLoading = false;
  String _statusMessage = '';
  bool _isSuccess = false;
  
  @override
  void initState() {
    super.initState();
    _testApiConnection();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _testApiConnection() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Testing API connection...';
    });

    try {
      final isConnected = await ApiService.testConnection();
      setState(() {
        _isLoading = false;
        _isSuccess = isConnected;
        _statusMessage = isConnected 
          ? '✅ API connection successful!' 
          : '❌ API connection failed. Check your backend.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _statusMessage = '❌ Error testing connection: $e';
      });
    }
  }

  Future<void> _testLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _statusMessage = '❌ Please enter email and password';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Testing login...';
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
        _isSuccess = success;
        _statusMessage = success 
          ? '✅ Login successful! User: ${authProvider.userName}' 
          : '❌ Login failed';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _statusMessage = '❌ Login error: $e';
      });
    }
  }

  Future<void> _testRegister() async {
    if (_fullNameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      setState(() {
        _statusMessage = '❌ Please fill all fields';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Testing registration...';
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.register(
        _fullNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
        _isSuccess = success;
        _statusMessage = success 
          ? '✅ Registration successful! User: ${authProvider.userName}' 
          : '❌ Registration failed';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _statusMessage = '❌ Registration error: $e';
      });
    }
  }

  Future<void> _testLogout() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Testing logout...';
    });

    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();

      setState(() {
        _isLoading = false;
        _isSuccess = true;
        _statusMessage = '✅ Logout successful!';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _statusMessage = '❌ Logout error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔐 Test Authentication'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppTheme.auroraGradient,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // API Connection Status
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '🌐 API Connection Test',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _statusMessage,
                        style: TextStyle(
                          color: _isSuccess ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _testApiConnection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Test Connection'),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Test Form
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '🧪 Test Authentication',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      
                      // Full Name (for registration)
                      TextField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Email
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      
                      // Password
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      
                      // Test Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _testLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Test Login'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _testRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Test Register'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      ElevatedButton(
                        onPressed: _isLoading ? null : _testLogout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Test Logout'),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Current Auth Status
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            '📊 Current Status',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text('Authenticated: ${authProvider.isAuthenticated ? "✅ Yes" : "❌ No"}'),
                          if (authProvider.userEmail != null)
                            Text('Email: ${authProvider.userEmail}'),
                          if (authProvider.userName != null)
                            Text('Name: ${authProvider.userName}'),
                          if (authProvider.userId != null)
                            Text('User ID: ${authProvider.userId}'),
                          if (authProvider.accessToken != null)
                            Text('Token: ${authProvider.accessToken!.substring(0, 20)}...'),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
