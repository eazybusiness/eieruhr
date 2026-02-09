import 'package:flutter/material.dart';
import '../models/timer_preset.dart';
import '../services/preset_service.dart';
import '../services/timer_service.dart';
import '../services/notification_service.dart';
import '../services/widget_service.dart';
import '../widgets/countdown_display.dart';
import '../widgets/preset_list.dart';
import '../widgets/preset_dialog.dart';

/// Main screen of the Eieruhr app showing countdown and presets.
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with WidgetsBindingObserver {
  final PresetService _presetService = PresetService();
  final TimerService _timerService = TimerService();
  final NotificationService _notificationService = NotificationService();
  final WidgetService _widgetService = WidgetService();

  List<TimerPreset> _presets = [];
  int? _selectedPresetIndex;
  String _activePresetName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {
    await _notificationService.init();
    final presets = await _presetService.loadPresets();
    setState(() {
      _presets = presets;
      _isLoading = false;
    });
    await _widgetService.syncPresetsToWidget(presets);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timerService.dispose();
    _notificationService.dispose();
    super.dispose();
  }

  /// Selects a preset and sets the timer duration.
  void _selectPreset(TimerPreset preset) {
    if (_timerService.isRunning) return;

    // Reason: Stop any alarm that might be playing before selecting new preset.
    if (_notificationService.isAlarmPlaying) {
      _notificationService.stopAlarm();
    }

    final index = _presets.indexOf(preset);
    _timerService.setDuration(preset.durationSeconds);
    setState(() {
      _selectedPresetIndex = index;
      _activePresetName = preset.name;
    });
  }

  /// Starts the countdown timer.
  void _startTimer() {
    _timerService.start(
      onTick: (remaining) {
        setState(() {});
      },
      onComplete: () {
        setState(() {});
        _onTimerComplete();
      },
    );
    setState(() {});
  }

  /// Called when the timer reaches zero.
  Future<void> _onTimerComplete() async {
    await _notificationService.showTimerFinishedNotification(_activePresetName);
    await _notificationService.playAlarm();
    setState(() {});
  }

  /// Stops the alarm and resets the timer.
  void _stopAlarm() {
    _notificationService.stopAlarm();
    _timerService.reset();
    setState(() {});
  }

  /// Pauses the timer.
  void _pauseTimer() {
    _timerService.pause();
    setState(() {});
  }

  /// Resets the timer to the selected preset's duration.
  void _resetTimer() {
    _timerService.reset();
    setState(() {});
  }

  /// Opens the dialog to add a new preset.
  Future<void> _addPreset() async {
    final preset = await showDialog<TimerPreset>(
      context: context,
      builder: (context) => const PresetDialog(),
    );
    if (preset != null) {
      final updatedPresets = await _presetService.addPreset(preset);
      setState(() {
        _presets = updatedPresets;
      });
      await _widgetService.syncPresetsToWidget(updatedPresets);
    }
  }

  /// Deletes a preset after confirmation.
  Future<void> _deletePreset(int index) async {
    final preset = _presets[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Löschen?'),
        content: Text('"${preset.name}" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final updatedPresets = await _presetService.removePreset(index);
      setState(() {
        _presets = updatedPresets;
        if (_selectedPresetIndex == index) {
          _selectedPresetIndex = null;
          _timerService.stop();
        }
      });
      await _widgetService.syncPresetsToWidget(updatedPresets);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isAlarmRinging = _notificationService.isAlarmPlaying;
    final isRunning = _timerService.isRunning;
    final hasTime = _timerService.totalSeconds > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eieruhr'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Countdown display.
            Center(
              child: CountdownDisplay(
                timeText: _timerService.formattedRemaining,
                progress: _timerService.progress,
                isRunning: isRunning,
                isAlarmRinging: isAlarmRinging,
              ),
            ),
            const SizedBox(height: 24),
            // Active preset name.
            if (_activePresetName.isNotEmpty)
              Text(
                _activePresetName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const SizedBox(height: 32),
            // Control buttons.
            _buildControlButtons(isRunning, isAlarmRinging, hasTime),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 8),
            // Section title.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Voreinstellungen',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addPreset,
                    tooltip: 'Neue Voreinstellung',
                  ),
                ],
              ),
            ),
            // Preset list.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: PresetList(
                  presets: _presets,
                  onPresetTap: _selectPreset,
                  onPresetLongPress: _deletePreset,
                  selectedIndex: _selectedPresetIndex,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the start/pause/stop/reset control buttons.
  Widget _buildControlButtons(
      bool isRunning, bool isAlarmRinging, bool hasTime) {
    if (isAlarmRinging) {
      return FilledButton.icon(
        onPressed: _stopAlarm,
        icon: const Icon(Icons.alarm_off),
        label: const Text('Alarm stoppen'),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isRunning && hasTime)
          FilledButton.icon(
            onPressed: _startTimer,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Starten'),
            style: FilledButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        if (isRunning) ...[
          FilledButton.tonalIcon(
            onPressed: _pauseTimer,
            icon: const Icon(Icons.pause),
            label: const Text('Pause'),
            style: FilledButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(width: 16),
        ],
        if (hasTime && !isRunning && _timerService.remainingSeconds != _timerService.totalSeconds)
          OutlinedButton.icon(
            onPressed: _resetTimer,
            icon: const Icon(Icons.refresh),
            label: const Text('Zurücksetzen'),
          ),
      ],
    );
  }
}
