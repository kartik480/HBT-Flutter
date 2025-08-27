# Habit Tracker - Flutter App

A professional and innovative habit tracking application built with Flutter, featuring a modern Material Design 3 interface with comprehensive analytics and habit management capabilities.

## 🚀 Features

### Core Functionality
- **Habit Management**: Create, edit, and delete habits with detailed customization
- **Progress Tracking**: Monitor daily completion and maintain streaks
- **Category Organization**: Organize habits into 7 different categories
- **Frequency Settings**: Support for daily, weekly, monthly, and custom frequencies
- **Reminder System**: Optional daily reminders for habit completion
- **Color Coding**: Personalize habits with custom colors

### User Interface
- **Modern Design**: Material Design 3 with custom theming
- **Responsive Layout**: Optimized for various screen sizes
- **Dark/Light Themes**: Automatic theme switching based on system preferences
- **Interactive Elements**: Smooth animations and intuitive gestures
- **Professional UI**: Clean, innovative interface with modern design principles

### Analytics & Insights
- **Progress Dashboard**: Real-time statistics and completion rates
- **Visual Charts**: Pie charts for habit completion analysis
- **Category Breakdown**: Detailed insights into habit distribution
- **Performance Metrics**: Streak tracking and top-performing habits
- **Trend Analysis**: Historical data visualization

### Data Management
- **Local Storage**: Persistent data using SharedPreferences
- **State Management**: Provider pattern for efficient state handling
- **Data Export**: JSON-based data persistence
- **Search & Filter**: Find habits quickly with category and text filters

## 🛠️ Technical Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **Charts**: fl_chart
- **Storage**: SharedPreferences
- **Architecture**: MVVM with Provider pattern
- **UI**: Material Design 3 with custom theming

## 📱 Screenshots

The app features several key screens:

1. **Home Dashboard**: Overview of today's habits and statistics
2. **Habit Creation**: Intuitive form for adding new habits
3. **Analytics**: Comprehensive progress visualization
4. **Category Management**: Organized habit browsing
5. **Progress Tracking**: Daily completion management

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 2.17 or higher
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/habit-tracker.git
   cd habit-tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS IPA:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── habit.dart           # Habit data model
├── providers/
│   └── habit_provider.dart  # State management
├── screens/
│   ├── home_screen.dart     # Main dashboard
│   ├── add_habit_screen.dart # Habit creation
│   └── analytics_screen.dart # Progress analytics
├── widgets/
│   ├── statistics_card.dart  # Stats display
│   ├── habit_list_tile.dart # Habit item
│   └── category_filter.dart # Category filtering
└── utils/
    └── app_theme.dart       # Theme configuration
```

## 🎨 Customization

### Themes
The app includes a comprehensive theme system with:
- Custom color palettes
- Material Design 3 components
- Dark and light mode support
- Consistent typography scales

### Colors
- Primary: Indigo (#6366F1)
- Secondary: Emerald (#10B981)
- Accent: Amber (#F59E0B)
- Success: Green (#10B981)
- Warning: Orange (#F59E0B)
- Error: Red (#EF4444)

## 🔧 Configuration

### Dependencies
Key dependencies in `pubspec.yaml`:
- `provider`: State management
- `shared_preferences`: Local data storage
- `fl_chart`: Data visualization
- `intl`: Internationalization support

### Environment Setup
Ensure your Flutter environment is properly configured:
```bash
flutter doctor
```

## 📊 Usage Guide

### Creating Habits
1. Tap the "+" button on the home screen
2. Fill in habit details (title, description, category)
3. Set frequency and target count
4. Choose custom color and optional reminder
5. Save the habit

### Tracking Progress
1. View today's habits on the home screen
2. Tap habit tiles to mark as complete/incomplete
3. Monitor streaks and completion rates
4. Use analytics to track long-term progress

### Managing Categories
1. Navigate to the Categories tab
2. Filter habits by category
3. View category-specific statistics
4. Organize habits for better productivity

## 🚀 Future Enhancements

- **Cloud Sync**: Multi-device synchronization
- **Social Features**: Share progress with friends
- **Advanced Analytics**: Machine learning insights
- **Notifications**: Smart reminder system
- **Data Export**: CSV/PDF reports
- **Widgets**: Home screen widgets
- **Backup/Restore**: Data backup functionality

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Open source community for various packages
- Contributors and beta testers

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Contact: your.email@example.com
- Documentation: [Wiki](https://github.com/yourusername/habit-tracker/wiki)

---

**Built with ❤️ using Flutter**
