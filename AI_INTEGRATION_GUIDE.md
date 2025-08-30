# AI Teacher Integration Guide

This guide explains how to integrate the AI Teacher system with your Flutter Habit Tracker app.

## 🚀 Quick Start

### 1. Start the AI Server
```bash
# Install Python dependencies
pip install -r requirements.txt

# Start the AI server
python start_ai_server.py
```

The server will start at `http://localhost:8000`

### 2. Run the Flutter App
```bash
flutter run
```

## 🔧 Integration Details

### What's Been Added

1. **AI Service** (`lib/services/ai_service.dart`)
   - HTTP client to communicate with the AI server
   - Methods for asking questions, getting insights, quotes, and coaching

2. **AI Chat Screen** (`lib/screens/ai_chat_screen.dart`)
   - Beautiful chat interface with the AI Teacher
   - Quick action buttons for insights and motivation
   - Real-time chat with loading indicators

3. **AI Icon Integration**
   - AI icon (🧠) positioned above the "Add Habit" button
   - Located at bottom right of the home screen
   - Uses cosmic gradient theme

### How It Works

1. **User taps the AI icon** → Opens AI Chat Screen
2. **AI Chat Screen connects** to the Python server via HTTP
3. **Server processes requests** using NLP, ML, and habit analysis
4. **Responses are displayed** in a beautiful chat interface

## 🌐 Server Configuration

### Default Settings
- **API Server**: `http://localhost:8000`
- **Web Interface**: `http://localhost:5000`
- **Flutter App**: Connects to `http://localhost:8000`

### Customizing Server URL
Edit `lib/services/ai_service.dart`:
```dart
static const String baseUrl = 'http://your-server-ip:8000';
```

## 📱 Flutter App Features

### AI Chat Interface
- **Real-time chat** with the AI Teacher
- **Quick actions** for common requests
- **Server status indicator** (green/red dot)
- **Beautiful gradients** matching app theme
- **Loading animations** during AI processing

### Quick Actions
- **Get Insights**: Personalized habit analysis
- **Motivation**: Inspirational quotes and encouragement

### Navigation
- **AI Icon**: Bottom right, above Add Habit button
- **Chat Screen**: Full-screen AI interaction
- **Back Button**: Returns to home screen

## 🔌 API Endpoints Used

The Flutter app communicates with these AI server endpoints:

- `POST /ai/ask` - Ask the AI a question
- `GET /ai/insights/{user_id}` - Get personalized insights
- `GET /ai/motivational-quote` - Get motivational quote
- `GET /ai/coaching/{user_id}` - Get coaching session
- `GET /health` - Check server availability

## 🎨 UI/UX Features

### Visual Design
- **Cosmic gradient** for AI elements
- **Consistent theming** with app design
- **Smooth animations** and transitions
- **Responsive layout** for different screen sizes

### User Experience
- **Intuitive navigation** with clear icons
- **Real-time feedback** for all actions
- **Error handling** with user-friendly messages
- **Offline awareness** with server status indicator

## 🚨 Troubleshooting

### Common Issues

1. **"AI server is not available"**
   - Check if Python server is running
   - Verify server URL in `ai_service.dart`
   - Check firewall/network settings

2. **Connection timeout**
   - Server might be overloaded
   - Check server logs for errors
   - Verify network connectivity

3. **Build errors**
   - Run `flutter pub get` to install http package
   - Check Flutter version compatibility
   - Clean and rebuild: `flutter clean && flutter build`

### Debug Steps

1. **Check server status**:
   ```bash
   curl http://localhost:8000/health
   ```

2. **Check Flutter logs**:
   ```bash
   flutter run --verbose
   ```

3. **Test API manually**:
   ```bash
   curl -X POST http://localhost:8000/ai/ask \
     -H "Content-Type: application/json" \
     -d '{"user_id": "test", "question": "Hello"}'
   ```

## 🔒 Security Considerations

### Current Implementation
- **HTTP only** (not HTTPS) for local development
- **No authentication** required for API access
- **Basic input validation** on server side

### Production Recommendations
- **Enable HTTPS** with SSL certificates
- **Add API authentication** (JWT tokens)
- **Implement rate limiting** to prevent abuse
- **Add input sanitization** for user queries
- **Use environment variables** for sensitive config

## 📈 Performance Optimization

### Flutter App
- **HTTP connection pooling** for multiple requests
- **Async/await** for non-blocking operations
- **State management** to prevent unnecessary rebuilds
- **Image caching** for AI avatars and icons

### AI Server
- **Database indexing** for faster queries
- **Response caching** for common questions
- **Background processing** for heavy computations
- **Connection pooling** for database access

## 🔮 Future Enhancements

### Planned Features
- **Voice chat** with speech-to-text
- **Push notifications** for AI insights
- **Offline mode** with cached responses
- **Multi-language support** for global users
- **Advanced analytics** dashboard

### Integration Possibilities
- **Wearable devices** (smartwatch integration)
- **Smart home** (IoT device control)
- **Calendar sync** (automatic scheduling)
- **Social features** (AI-powered community)

## 📚 Additional Resources

### Documentation
- [AI Teacher README](AI_TEACHER_README.md)
- [Flutter HTTP Package](https://pub.dev/packages/http)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)

### Code Examples
- [AI Service Implementation](lib/services/ai_service.dart)
- [Chat Screen UI](lib/screens/ai_chat_screen.dart)
- [Server API Code](ai_teacher_api.py)

### Support
- Check GitHub issues for known problems
- Review server logs for error details
- Test API endpoints independently
- Verify network connectivity

## 🎯 Getting Help

If you encounter issues:

1. **Check the logs** (both Flutter and Python)
2. **Verify server status** with health endpoint
3. **Test API manually** with curl/Postman
4. **Review this guide** for common solutions
5. **Check dependencies** are properly installed

The AI Teacher integration brings intelligent habit coaching directly to your Flutter app, providing users with personalized guidance, motivation, and insights to help them build better habits! 🚀
