import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// Service that manages the foreground task to keep the app alive
/// during timer countdown, ensuring the alarm can sound even when the
/// screen is off or the app is in the background.
class ForegroundService {
  static final ForegroundService _instance = ForegroundService._internal();

  factory ForegroundService() => _instance;

  ForegroundService._internal();

  bool _isRunning = false;

  /// Whether the foreground service is currently running.
  bool get isRunning => _isRunning;

  /// Callback that will be invoked when the timer completes
  /// while running in the foreground task.
  void Function()? onTimerComplete;

  /// Initializes the foreground task configuration.
  ///
  /// Must be called before starting the service.
  void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'eieruhr_foreground',
        channelName: 'Eieruhr Timer',
        channelDescription: 'Timer läuft im Hintergrund',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
  }

  /// Starts the foreground service with the given [endTime].
  ///
  /// The service will keep the app alive until [endTime] is reached.
  /// When the timer completes, [onComplete] will be called.
  Future<void> start({
    required DateTime endTime,
    required String presetName,
    required void Function() onComplete,
  }) async {
    if (_isRunning) {
      await stop();
    }

    onTimerComplete = onComplete;
    _isRunning = true;

    // Request permission for notifications (required for foreground service)
    final notificationPermission = await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    // Start the foreground service
    await FlutterForegroundTask.startService(
      notificationTitle: 'Eieruhr läuft',
      notificationText: '$presetName - Timer aktiv',
      callback: _startCallback,
    );

    // Send the end time to the task via FlutterForegroundTask
    FlutterForegroundTask.sendDataToTask(endTime.millisecondsSinceEpoch);
  }

  /// Stops the foreground service.
  Future<void> stop() async {
    _isRunning = false;
    onTimerComplete = null;
    await FlutterForegroundTask.stopService();
  }

  /// Updates the notification text while the service is running.
  Future<void> updateNotification({
    required String title,
    required String text,
  }) async {
    if (!_isRunning) return;
    await FlutterForegroundTask.updateService(
      notificationTitle: title,
      notificationText: text,
    );
  }
}

/// The callback function that runs in the foreground task isolate.
@pragma('vm:entry-point')
void _startCallback() {
  FlutterForegroundTask.setTaskHandler(EieruhrTaskHandler());
}

/// Task handler that runs in the background isolate.
///
/// This handler receives the end time via the send port and checks
/// periodically if the timer has completed.
class EieruhrTaskHandler extends TaskHandler {
  DateTime? _endTime;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // Task started - waiting for end time data
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    // Check if timer has completed
    if (_endTime != null) {
      final now = DateTime.now();
      if (now.isAfter(_endTime!)) {
        // Timer complete - notify the main isolate
        FlutterForegroundTask.sendDataToMain('timer_complete');
      }
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    _endTime = null;
  }

  @override
  void onReceiveData(Object data) {
    // Receive end time from main isolate
    if (data is int) {
      _endTime = DateTime.fromMillisecondsSinceEpoch(data);
    }
  }

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {}

}
