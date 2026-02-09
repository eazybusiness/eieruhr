# Eieruhr – Project Planning

## 🎯 Vision
A simple, focused Android countdown timer app ("Eieruhr" = egg timer) with a home screen widget. Users can save preset timers (e.g., "Eier 6:20", "Brot 30:00") and start them with a single tap from the widget or the app.

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter (Dart)
- **Target Platform**: Android only
- **State Management**: StatefulWidget + setState (simple app, no need for complex state management)
- **Local Storage**: SharedPreferences (for saving timer presets)
- **Home Screen Widget**: `home_widget` package (Flutter ↔ Android native widget bridge)
- **Notifications/Alarm**: `flutter_local_notifications` + `audioplayers` for alarm sound
- **Background Execution**: `android_alarm_manager_plus` for reliable timer completion even when app is in background

### Project Structure
```
eieruhr/
├── lib/
│   ├── main.dart                  # App entry point
│   ├── models/
│   │   └── timer_preset.dart      # TimerPreset data model
│   ├── screens/
│   │   └── timer_screen.dart      # Main timer screen
│   ├── services/
│   │   ├── preset_service.dart    # Load/save presets via SharedPreferences
│   │   ├── timer_service.dart     # Countdown timer logic
│   │   └── notification_service.dart  # Alarm/notification handling
│   └── widgets/
│       ├── countdown_display.dart # Circular countdown display widget
│       ├── preset_list.dart       # List of saved presets
│       └── preset_dialog.dart     # Dialog to add/edit a preset
├── android/
│   └── app/src/main/
│       ├── java/.../             # Native widget code (AppWidgetProvider)
│       └── res/
│           ├── layout/widget_layout.xml
│           └── xml/widget_info.xml
├── test/
│   ├── models/
│   │   └── timer_preset_test.dart
│   ├── services/
│   │   ├── preset_service_test.dart
│   │   └── timer_service_test.dart
│   └── widgets/
│       └── countdown_display_test.dart
├── PLANNING.md
├── TASK.md
├── README.md
└── pubspec.yaml
```

## 🎨 UI Design

### Main Screen
- **Top**: Large circular countdown display (MM:SS)
- **Center**: List of saved presets as tappable cards/chips
- **Bottom**: Start/Stop/Reset buttons
- **FAB**: Add new preset

### Interaction Flow
1. User opens app → sees preset list + countdown at 00:00
2. User taps a preset → countdown is set to that duration
3. User taps "Start" → countdown begins
4. Timer reaches 00:00 → alarm sound plays, notification shown
5. User taps "Stop" or dismisses notification → alarm stops

### Home Screen Widget
- Compact widget showing preset buttons (e.g., "Eier", "Brot")
- Tapping a button starts the timer immediately
- Shows remaining time while a timer is running
- Tap to dismiss/stop when alarm is ringing

## 📋 Constraints
- **Simplicity first**: No over-engineering. This is a utility app.
- **Offline only**: No network requests, no backend.
- **Single screen**: Everything on one screen, dialogs for add/edit.
- **German UX**: UI text in German (Eieruhr, Starten, Stoppen, etc.)
- **English code**: All code, comments, and documentation in English.

## 📦 Key Dependencies
| Package | Purpose |
|---------|---------|
| `home_widget` | Android home screen widget support |
| `flutter_local_notifications` | Show notification when timer completes |
| `audioplayers` | Play alarm sound |
| `shared_preferences` | Persist timer presets locally |
