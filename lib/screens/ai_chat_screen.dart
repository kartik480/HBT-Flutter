import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:habit_tracker/services/ai_service.dart';
import 'package:habit_tracker/utils/app_theme.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isServerAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkServerAvailability();
    _addWelcomeMessage();
  }

  Future<void> _checkServerAvailability() async {
    final isAvailable = await AIService.isServerAvailable();
    setState(() {
      _isServerAvailable = isAvailable;
    });
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      text: "Hello! I'm your AI Teacher. I'm here to help you with:\n\n"
          "• Habit guidance and motivation\n"
          "• Personalized insights and analysis\n"
          "• Smart reminders and suggestions\n"
          "• Progress tracking and goal setting\n\n"
          "How can I help you today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.userId ?? 'default_user';
      
      final response = await AIService.askAI(userId, message);
      
      setState(() {
        _messages.add(ChatMessage(
          text: response['response'] ?? 'Sorry, I couldn\'t process your request.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I\'m having trouble connecting to my brain right now. Please try again later.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _getQuickInsights() async {
    if (!_isServerAvailable) {
      _showServerUnavailableMessage();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.userId ?? 'default_user';
      
      final insights = await AIService.getInsights(userId);
      
      setState(() {
        _messages.add(ChatMessage(
          text: insights['insights'] ?? 'I couldn\'t generate insights right now.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I couldn\'t generate insights right now.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  Future<void> _getMotivationalQuote() async {
    if (!_isServerAvailable) {
      _showServerUnavailableMessage();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final quote = await AIService.getMotivationalQuote();
      
      setState(() {
        _messages.add(ChatMessage(
          text: quote['quote'] ?? 'I couldn\'t find a quote right now.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I couldn\'t find a motivational quote right now.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  Future<void> _startCoachingSession() async {
    if (!_isServerAvailable) {
      _showServerUnavailableMessage();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.userId ?? 'default_user';
      
      final response = await AIService.getCoachingSession(userId, 'general');
      
      if (response['success'] == true) {
        final session = response['coaching_session'];
        final message = session['message'] ?? '';
        final motivation = session['motivation'] ?? '';
        final recommendations = session['recommendations'] ?? [];
        
        String fullMessage = "🎯 Coaching Session Started!\n\n";
        fullMessage += "$message\n\n";
        
        if (motivation.isNotEmpty) {
          fullMessage += "💪 $motivation\n\n";
        }
        
        if (recommendations.isNotEmpty) {
          fullMessage += "💡 Recommendations:\n";
          for (int i = 0; i < recommendations.length && i < 3; i++) {
            fullMessage += "• ${recommendations[i]}\n";
          }
        }
        
        setState(() {
          _messages.add(ChatMessage(
            text: fullMessage,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add(ChatMessage(
            text: 'Sorry, I couldn\'t start a coaching session right now. Please try again later.',
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Error starting coaching session: $e',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _showServerUnavailableMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI server is not available. Please check your connection.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppTheme.auroraGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildQuickActions(),
              Expanded(
                child: _buildChatArea(),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppTheme.cosmicGradient),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'AI Teacher',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _isServerAvailable ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionButton(
              'Get Insights',
              Icons.lightbulb,
              _getQuickInsights,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionButton(
              'Motivation',
              Icons.favorite,
              _getMotivationalQuote,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionButton(
              'Coaching',
              Icons.school,
              _startCoachingSession,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppTheme.forestGradient),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.forestGradient.first.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: _messages.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _messages.length) {
              return _buildLoadingIndicator();
            }
            return _buildMessage(_messages[index]);
          },
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppTheme.cosmicGradient),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppTheme.fireGradient.first.withOpacity(0.9)
                    : Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isUser ? 20 : 5),
                  bottomRight: Radius.circular(message.isUser ? 5 : 20),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppTheme.fireGradient),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppTheme.cosmicGradient),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.cosmicGradient.first,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Thinking...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Ask me anything...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppTheme.fireGradient),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.fireGradient.first.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
