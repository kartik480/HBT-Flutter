# OpenRouter API Integration with AI Teacher

## Overview

This document explains how the AI Teacher system has been integrated with OpenRouter API to provide powerful AI-powered habit coaching and guidance. The integration allows the AI Teacher to leverage state-of-the-art language models like Grok, Claude, and others for more intelligent and contextual responses.

## What is OpenRouter?

OpenRouter is a unified API that provides access to multiple AI models from various providers including:
- **xAI (Grok)**: Fast, efficient AI model
- **Anthropic (Claude)**: Advanced reasoning and safety-focused AI
- **OpenAI (GPT)**: Versatile language models
- **Google (Gemini)**: Multimodal AI capabilities
- And many more...

## Integration Benefits

### 1. **Enhanced AI Responses**
- More natural and contextual conversations
- Better understanding of user intent and sentiment
- Improved habit formation advice and motivation

### 2. **Model Flexibility**
- Easy switching between different AI models
- Fallback to local processing if API is unavailable
- Cost-effective model selection based on use case

### 3. **Scalability**
- Handles multiple concurrent users
- Automatic rate limiting and error handling
- Robust fallback mechanisms

## Architecture

```
Flutter App → AI Service → FastAPI Server → AI Teacher → OpenRouter API
     ↓              ↓           ↓           ↓           ↓
  User Input   HTTP Request   Endpoint   Process    AI Model
     ↓              ↓           ↓           ↓           ↓
  AI Response  HTTP Response  JSON Data  Context    Response
```

## Configuration

### API Key Setup
The OpenRouter API key is configured in `ai_teacher.py`:

```python
self.openrouter_api_key = "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"
self.openrouter_url = "https://openrouter.ai/api/v1/chat/completions"
```

### Model Selection
Default model is `x-ai/grok-code-fast-1`, but you can easily change it:

```python
# In _call_openrouter_api method
model: str = "x-ai/grok-code-fast-1"  # Change this to any supported model
```

## API Endpoints

### 1. **POST /ai/ask**
Main endpoint for asking AI questions.

**Request:**
```json
{
  "user_id": "user123",
  "question": "How can I build better exercise habits?"
}
```

**Response:**
```json
{
  "success": true,
  "response": "Here's how to build better exercise habits...",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### 2. **POST /ai/insights**
Get personalized insights and recommendations.

**Request:**
```json
{
  "user_id": "user123"
}
```

**Response:**
```json
{
  "success": true,
  "insights": {
    "habit_analysis": {...},
    "recommendations": [...],
    "best_times": {...},
    "consistency_scores": {...}
  }
}
```

### 3. **GET /ai/motivational-quote**
Get motivational quotes (optional context).

**Request:**
```
GET /ai/motivational-quote?context=exercise
```

**Response:**
```json
{
  "success": true,
  "quote": "The only bad workout is the one that didn't happen.",
  "context": "exercise"
}
```

### 4. **POST /ai/coaching-session**
Start a personalized coaching session.

**Request:**
```json
{
  "user_id": "user123",
  "session_type": "general"
}
```

## Flutter Integration

### AI Service
The Flutter app communicates with the AI server through `AIService`:

```dart
// Ask AI a question
final response = await AIService.askAI(userId, question);

// Get insights
final insights = await AIService.getInsights(userId);

// Get motivational quote
final quote = await AIService.getMotivationalQuote();

// Start coaching session
final session = await AIService.getCoachingSession(userId, 'general');
```

### AI Chat Screen
The main AI interface includes:
- **Chat History**: Real-time conversation with AI
- **Quick Actions**: 
  - Get Insights
  - Motivation
  - Coaching Session
- **Server Status**: Visual indicator of AI server availability

## Error Handling & Fallbacks

### 1. **API Failures**
If OpenRouter API fails, the system falls back to local processing:
- Pattern-based intent recognition
- Pre-defined motivational quotes
- Rule-based habit advice

### 2. **Network Issues**
- Automatic retry mechanisms
- User-friendly error messages
- Graceful degradation

### 3. **Rate Limiting**
- Automatic request throttling
- Queue management for high-traffic periods

## Testing

### Test Script
Run the test script to verify integration:

```bash
python test_openrouter.py
```

This script tests:
- Direct OpenRouter API connectivity
- AI Teacher integration
- Response handling
- Multiple model support

### Manual Testing
1. Start the AI server: `python start_ai_server.py`
2. Open the Flutter app
3. Navigate to AI Chat screen
4. Test various queries and quick actions

## Security Considerations

### 1. **API Key Protection**
- API key is embedded in server code (not client)
- Consider using environment variables for production
- Implement API key rotation

### 2. **Request Validation**
- Input sanitization and validation
- Rate limiting per user
- CORS configuration for web access

### 3. **Data Privacy**
- User data is processed locally when possible
- Minimal data sent to external APIs
- Compliance with privacy regulations

## Performance Optimization

### 1. **Caching**
- Cache frequently requested responses
- Store user insights locally
- Implement response memoization

### 2. **Async Processing**
- Non-blocking API calls
- Background learning processes
- Efficient database operations

### 3. **Resource Management**
- Connection pooling
- Memory-efficient response handling
- Automatic cleanup of unused resources

## Monitoring & Logging

### 1. **API Metrics**
- Request/response times
- Success/failure rates
- Model usage statistics

### 2. **Error Tracking**
- Detailed error logs
- Stack traces for debugging
- User impact assessment

### 3. **Performance Monitoring**
- Response time tracking
- Resource usage monitoring
- Alert systems for issues

## Troubleshooting

### Common Issues

#### 1. **API Key Invalid**
```
Error: 401 Unauthorized
Solution: Verify API key in ai_teacher.py
```

#### 2. **Rate Limit Exceeded**
```
Error: 429 Too Many Requests
Solution: Implement request throttling
```

#### 3. **Model Not Available**
```
Error: 400 Bad Request
Solution: Check model name and availability
```

#### 4. **Network Timeout**
```
Error: Connection timeout
Solution: Check internet connection and firewall settings
```

### Debug Steps
1. Check server logs for detailed error messages
2. Verify API key validity
3. Test API connectivity with test script
4. Check network configuration
5. Verify model availability

## Future Enhancements

### 1. **Advanced Models**
- Integration with newer AI models
- Multimodal capabilities (image, voice)
- Real-time learning and adaptation

### 2. **Personalization**
- User preference learning
- Adaptive coaching styles
- Personalized habit recommendations

### 3. **Analytics**
- Advanced user behavior analysis
- Predictive habit success modeling
- Performance optimization insights

## Support & Resources

### Documentation
- [OpenRouter API Documentation](https://openrouter.ai/docs)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Flutter HTTP Package](https://pub.dev/packages/http)

### Community
- OpenRouter Discord: [Join here](https://discord.gg/openrouter)
- GitHub Issues: Report bugs and feature requests
- Stack Overflow: Community support

### Contact
For technical support or questions about this integration:
- Create an issue in the project repository
- Contact the development team
- Check the troubleshooting section above

---

**Note**: This integration provides a powerful foundation for AI-powered habit coaching. Regular updates and monitoring ensure optimal performance and user experience.
