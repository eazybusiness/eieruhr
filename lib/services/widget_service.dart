import 'package:home_widget/home_widget.dart';
import '../models/timer_preset.dart';

/// Service for syncing timer presets to the Android home screen widget.
class WidgetService {
  /// Syncs the first two presets to the home screen widget via SharedPreferences.
  ///
  /// The native Android widget reads these values to display preset buttons.
  Future<void> syncPresetsToWidget(List<TimerPreset> presets) async {
    if (presets.isNotEmpty) {
      await HomeWidget.saveWidgetData('preset_0_name', presets[0].name);
      await HomeWidget.saveWidgetData(
          'preset_0_duration', presets[0].durationSeconds);
    }
    if (presets.length > 1) {
      await HomeWidget.saveWidgetData('preset_1_name', presets[1].name);
      await HomeWidget.saveWidgetData(
          'preset_1_duration', presets[1].durationSeconds);
    }

    // Reason: Trigger the native widget to refresh and pick up new data.
    await HomeWidget.updateWidget(
      androidName: 'EieruhrWidgetProvider',
    );
  }

  /// Updates the widget to show the current timer state.
  Future<void> updateTimerState({
    required bool isRunning,
    required String remainingTime,
    required String presetName,
  }) async {
    await HomeWidget.saveWidgetData('is_running', isRunning);
    await HomeWidget.saveWidgetData('remaining_time', remainingTime);
    await HomeWidget.saveWidgetData('active_preset', presetName);
    await HomeWidget.updateWidget(
      androidName: 'EieruhrWidgetProvider',
    );
  }
}
