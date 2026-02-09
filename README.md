# Eieruhr 🥚⏱️

A simple Android countdown timer app with a home screen widget. Save preset timers (e.g., "Eier 6:20", "Brot 30:00") and start them with a single tap.

## Features

- **Countdown Timer** – Large circular display with MM:SS countdown
- **Preset Management** – Save, add, and delete custom timer presets
- **Home Screen Widget** – Start timers directly from the Android home screen
- **Alarm Notification** – Sound + notification when the timer finishes
- **Material 3 UI** – Modern Material You design with light/dark theme support

## Default Presets

| Name | Duration |
|------|----------|
| Eier | 06:20 |
| Brot | 30:00 |

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2+)
- Android SDK
- A connected Android device or emulator

### Install & Run
```bash
flutter pub get
flutter run
```

### Run Tests
```bash
flutter test
```

### Analyze
```bash
flutter analyze
```

## Project Structure
```
lib/
├── main.dart                     # App entry point
├── models/
│   └── timer_preset.dart         # TimerPreset data model
├── screens/
│   └── timer_screen.dart         # Main timer screen
├── services/
│   ├── preset_service.dart       # Preset persistence (SharedPreferences)
│   ├── timer_service.dart        # Countdown timer logic
│   ├── notification_service.dart # Alarm + notifications
│   └── widget_service.dart       # Home screen widget sync
└── widgets/
    ├── countdown_display.dart    # Circular countdown UI
    ├── preset_list.dart          # Preset chips list
    └── preset_dialog.dart        # Add/edit preset dialog
```

## Dependencies
- `shared_preferences` – Persist timer presets locally
- `home_widget` – Android home screen widget support
- `flutter_local_notifications` – Timer completion notifications
- `audioplayers` – Alarm sound playback

## Usage
1. Open the app → default presets (Eier, Brot) are shown
2. Tap a preset → countdown is set
3. Tap "Starten" → countdown begins
4. Timer reaches 00:00 → alarm rings + notification
5. Tap "Alarm stoppen" → silence and reset
6. Long-press a preset → delete it
7. Tap + → add a new custom preset

### Home Screen Widget
1. Long-press your Android home screen → Widgets
2. Find "Eieruhr" and place it
3. Tap a preset button on the widget → app opens and timer starts
