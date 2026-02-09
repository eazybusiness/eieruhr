# Eieruhr – Task Tracking

## ✅ Completed
- [x] Create Windsurf workspace rules adapted for Flutter/Dart (2026-02-09)
- [x] Create PLANNING.md (2026-02-09)
- [x] Create TASK.md (2026-02-09)

### Milestone 1: Project Setup
- [x] Initialize Flutter project with `flutter create` (2026-02-09)
- [x] Configure `pubspec.yaml` with dependencies (2026-02-09)
- [x] Set up `.gitignore` and `git init` (2026-02-09)
- [x] Initial git commit (2026-02-09)

### Milestone 2: Core App
- [x] Create `TimerPreset` data model (2026-02-09)
- [x] Implement `PresetService` (SharedPreferences CRUD) (2026-02-09)
- [x] Implement `TimerService` (countdown logic) (2026-02-09)
- [x] Implement `NotificationService` (alarm + notification) (2026-02-09)
- [x] Build main timer screen UI (2026-02-09)
- [x] Build countdown display widget (2026-02-09)
- [x] Build preset list widget (2026-02-09)
- [x] Build add/edit preset dialog (2026-02-09)
- [x] Add default presets (Eier 6:20, Brot 30:00) (2026-02-09)

### Milestone 3: Android Widget
- [x] Set up `home_widget` package (2026-02-09)
- [x] Create native Android widget layout (XML) (2026-02-09)
- [x] Create AppWidgetProvider (Kotlin) (2026-02-09)
- [x] Wire widget button taps to start timer (2026-02-09)
- [x] WidgetService to sync presets to widget (2026-02-09)

### Milestone 4: Testing
- [x] Unit tests for `TimerPreset` model – 7 tests (2026-02-09)
- [x] Unit tests for `TimerService` – 9 tests (2026-02-09)
- [x] Widget tests for countdown display – 4 tests (2026-02-09)
- [x] All 20 tests passing (2026-02-09)

### Milestone 5: Deploy to Device
- [x] Run `flutter devices` – found SM A546E (2026-02-09)
- [x] Build and install on device (release mode) (2026-02-09)
- [ ] Manual smoke test

## 🔨 Active Tasks
- (none – awaiting smoke test results)

## 📝 Backlog
- (none yet)

## 🔍 Discovered During Work
- `flutter_local_notifications` requires core library desugaring – fixed in `build.gradle.kts` (2026-02-09)
