import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

/// Service for showing notifications and playing alarm sounds.
///
/// Supports scheduling a notification at a future [DateTime] so the alarm
/// fires even when the screen is off or the app is in the background.
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAlarmPlaying = false;

  /// Whether the alarm is currently playing.
  bool get isAlarmPlaying => _isAlarmPlaying;

  /// Initializes the notification plugin and timezone data.
  Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (_) {
        // Reason: Tapping the notification should stop the alarm.
        stopAlarm();
      },
    );

    // Request notification permission on Android 13+.
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Request exact alarm permission on Android 14+.
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  /// Schedules a notification at [endTime] that will fire even when the
  /// screen is off.
  ///
  /// Also starts the alarm sound when the notification fires.
  Future<void> scheduleAlarmAt({
    required DateTime endTime,
    required String presetName,
  }) async {
    // Cancel any previously scheduled notification.
    await _notifications.cancelAll();

    final scheduledDate = tz.TZDateTime.from(endTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'eieruhr_alarm',
      'Timer Alarm',
      channelDescription: 'Alarm wenn der Timer abgelaufen ist',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      sound: RawResourceAndroidNotificationSound('alarm'),
      playSound: true,
      enableVibration: true,
      ongoing: true,
      autoCancel: false,
    );
    const details = NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      0,
      'Eieruhr',
      '$presetName ist fertig!',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancels any scheduled notification (e.g. when pausing or stopping).
  Future<void> cancelScheduledAlarm() async {
    await _notifications.cancelAll();
  }

  /// Shows an immediate notification that the timer has finished.
  Future<void> showTimerFinishedNotification(String presetName) async {
    const androidDetails = AndroidNotificationDetails(
      'eieruhr_alarm',
      'Timer Alarm',
      channelDescription: 'Alarm wenn der Timer abgelaufen ist',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      playSound: false, // Reason: We play our own alarm sound via audioplayers.
      ongoing: true,
      autoCancel: false,
    );
    const details = NotificationDetails(android: androidDetails);
    await _notifications.show(
      0,
      'Eieruhr',
      '$presetName ist fertig!',
      details,
    );
  }

  /// Plays the alarm sound in a loop.
  Future<void> playAlarm() async {
    _isAlarmPlaying = true;
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    // Reason: Using a system-provided alarm URI as a reliable default sound.
    await _audioPlayer.play(
      UrlSource('https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg'),
    );
  }

  /// Stops the alarm sound and cancels notifications.
  Future<void> stopAlarm() async {
    _isAlarmPlaying = false;
    await _audioPlayer.stop();
    await _notifications.cancelAll();
  }

  /// Disposes resources.
  void dispose() {
    _audioPlayer.dispose();
  }
}
