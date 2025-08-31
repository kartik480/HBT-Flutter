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
  bool _isTyping = false;

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
    
    if (!isAvailable) {
      _addSystemMessage(
        "⚠️ AI Server Unavailable\n\nI'm currently offline, but I can still help you with basic habit tracking questions. "
        "Please check your internet connection and try again later.",
      );
    }
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      text: "👋 Hello! I'm your AI Teacher, your personal habit coach and motivator!\n\n"
          "🎯 **What I can help you with:**\n"
          "• Building better habits and breaking bad ones\n"
          "• Personalized motivation and encouragement\n"
          "• Smart habit analysis and recommendations\n"
          "• Progress tracking and goal setting\n"
          "• Overcoming obstacles and staying consistent\n\n"
          "💡 **Quick Actions:** Use the buttons below for instant help!\n\n"
          "What would you like to work on today?",
      isUser: false,
      timestamp: DateTime.now(),
      messageType: MessageType.ai,
    ));
  }

  void _addSystemMessage(String text) {
    _messages.add(ChatMessage(
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
      messageType: MessageType.system,
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
        messageType: MessageType.user,
      ));
      _isLoading = true;
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.userId ?? 'default_user';
      
      // Show typing indicator
      _showTypingIndicator();
      
      final response = await AIService.askAI(userId, message);
      
      // Remove typing indicator
      _removeTypingIndicator();
      
      setState(() {
        _messages.add(ChatMessage(
          text: response['response'] ?? _getFallbackResponse(message),
          isUser: false,
          timestamp: DateTime.now(),
          messageType: MessageType.ai,
        ));
        _isLoading = false;
      });
    } catch (e) {
      _removeTypingIndicator();
      setState(() {
        _messages.add(ChatMessage(
          text: _getFallbackResponse(message),
          isUser: false,
          timestamp: DateTime.now(),
          messageType: MessageType.system,
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _showTypingIndicator() {
    setState(() {
      _messages.add(ChatMessage(
        text: "🤔 Thinking...",
        isUser: false,
        timestamp: DateTime.now(),
        messageType: MessageType.typing,
      ));
    });
    _scrollToBottom();
  }

  void _removeTypingIndicator() {
    setState(() {
      if (_messages.isNotEmpty && _messages.last.messageType == MessageType.typing) {
        _messages.removeLast();
      }
    });
  }

  String _getFallbackResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    if (message.contains('habit') || message.contains('routine')) {
      return "💡 **Habit Building Tip:** Start small! Choose one habit and commit to it for just 2 minutes a day. "
             "Once that becomes automatic, gradually increase the time. Remember, consistency beats perfection every time!";
    } else if (message.contains('motivation') || message.contains('motivated')) {
      return "🔥 **Motivation Boost:** You don't need motivation to start - you need discipline to continue! "
             "Think about your future self. What would they thank you for doing today?";
    } else if (message.contains('exercise') || message.contains('workout')) {
      return "🏃‍♂️ **Exercise Motivation:** Movement is medicine! Even 10 minutes of walking can boost your mood and energy. "
             "Start with what feels good and build from there. Your body will thank you!";
    } else if (message.contains('sleep') || message.contains('bedtime')) {
      return "😴 **Sleep Tips:** Create a relaxing bedtime routine. Avoid screens 1 hour before bed, "
             "try reading or meditation. Consistency in sleep schedule is key to better rest!";
    } else if (message.contains('diet') || message.contains('food') || message.contains('eat')) {
      return "🥗 **Healthy Eating:** Focus on adding good foods rather than restricting. "
             "Start your day with protein, stay hydrated, and remember - progress, not perfection!";
    } else {
      return "💭 **Personal Reflection:** That's an interesting question! While I'm offline, "
             "take a moment to reflect on what you really want to achieve. "
             "Sometimes the best answers come from within. What's your gut feeling?";
    }
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
          text: insights['insights'] ?? _getDefaultInsights(),
          isUser: false,
          timestamp: DateTime.now(),
          messageType: MessageType.ai,
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: _getDefaultInsights(),
          isUser: false,
          timestamp: DateTime.now(),
          messageType: MessageType.system,
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  String _getDefaultInsights() {
    return "🔍 **Quick Habit Insights:**\n\n"
           "📊 **Focus Areas:**\n"
           "• Morning routines are most successful when done consistently\n"
           "• Exercise habits work best when scheduled at the same time daily\n"
           "• Small wins build momentum - celebrate every step forward\n\n"
           "💡 **Pro Tips:**\n"
           "• Stack new habits onto existing ones\n"
           "• Use visual cues and reminders\n"
           "• Track progress to stay motivated\n\n"
           "🎯 **Next Steps:** Pick one area to focus on this week!";
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
          text: quote['quote'] ?? _getDefaultMotivationalQuote(),
          isUser: false,
          timestamp: DateTime.now(),
          messageType: MessageType.ai,
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: _getDefaultMotivationalQuote(),
          isUser: false,
          timestamp: DateTime.now(),
          messageType: MessageType.system,
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  String _getDefaultMotivationalQuote() {
    return "💪 **Daily Motivation:**\n\n"
           "\"The only bad workout is the one that didn't happen.\"\n\n"
           "Every step forward, no matter how small, is progress. "
           "Your future self is watching and cheering you on! "
           "What will you do today to make them proud?";
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
      
      setState(() {
        _messages.add(ChatMessage(
          text: response['session'] ?? _getDefaultCoachingSession(),
          isUser: false,
          timestamp: DateTime.now(),
          messageType: MessageType.ai,
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: _getDefaultCoachingSession(),
          isUser: false,
          timestamp: DateTime.now(),
          messageType: MessageType.system,
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  String _getDefaultCoachingSession() {
    return "🎓 **Coaching Session: Building Your Foundation**\n\n"
           "Let's create a solid foundation for your habit journey:\n\n"
           "1️⃣ **Identify Your Why:** What's driving you to change?\n"
           "2️⃣ **Choose Your Keystone Habit:** What one habit will improve everything else?\n"
           "3️⃣ **Set Up Your Environment:** Remove obstacles, add reminders\n"
           "4️⃣ **Start Small:** 2 minutes a day to begin\n"
           "5️⃣ **Track Progress:** Use your habit tracker consistently\n\n"
           "Ready to begin? What's your biggest challenge right now?";
  }

  void _showServerUnavailableMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI Server is currently unavailable. Using offline mode.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.psychology, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('AI Teacher'),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isServerAvailable ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isServerAvailable ? Icons.wifi : Icons.wifi_off,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildChatList(),
          ),
          _buildQuickActions(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageTile(message);
      },
    );
  }

  Widget _buildMessageTile(ChatMessage message) {
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
                  gradient: LinearGradient(
                    colors: message.messageType == MessageType.ai 
                        ? AppTheme.cosmicGradient 
                        : AppTheme.auroraGradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              child: Icon(
                message.messageType == MessageType.ai 
                    ? Icons.psychology 
                    : Icons.info,
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
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: message.isUser 
                      ? AppTheme.primaryColor.withOpacity(0.3)
                      : Colors.grey[300]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: message.isUser 
                          ? AppTheme.primaryColor 
                          : Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
                              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppTheme.auroraGradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionButton(
              '💡 Insights',
              Icons.lightbulb,
              _getQuickInsights,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionButton(
              '🔥 Motivation',
              Icons.favorite,
              _getMotivationalQuote,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionButton(
              '🎓 Coaching',
              Icons.school,
              _startCoachingSession,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask me anything about habits...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                suffixIcon: _isLoading
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
              onSubmitted: (_) => _sendMessage(),
              enabled: !_isLoading,
            ),
          ),
          const SizedBox(width: 12),
                      Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppTheme.cosmicGradient,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
            child: IconButton(
              onPressed: _isLoading ? null : _sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16),
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
  final MessageType messageType;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.messageType = MessageType.user,
  });
}

enum MessageType {
  user,
  ai,
  system,
  typing,
}
