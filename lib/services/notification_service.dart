import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

/// Service for showing notifications and playing alarm sounds.
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAlarmPlaying = false;

  /// Whether the alarm is currently playing.
  bool get isAlarmPlaying => _isAlarmPlaying;

  /// Initializes the notification plugin.
  Future<void> init() async {
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
  }

  /// Shows a notification that the timer has finished.
  Future<void> showTimerFinishedNotification(String presetName) async {
    const androidDetails = AndroidNotificationDetails(
      'eieruhr_timer',
      'Timer Benachrichtigungen',
      channelDescription: 'Benachrichtigung wenn der Timer abgelaufen ist',
      importance: Importance.high,
      priority: Priority.high,
      playSound: false, // Reason: We play our own alarm sound via audioplayers.
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

  /// Stops the alarm sound.
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
