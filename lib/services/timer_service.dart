import 'dart:async';

/// Callback type for timer tick events.
typedef TimerTickCallback = void Function(int remainingSeconds);

/// Callback type for timer completion.
typedef TimerCompleteCallback = void Function();

/// Service that manages the countdown timer logic.
class TimerService {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _isRunning = false;

  /// Current remaining seconds on the timer.
  int get remainingSeconds => _remainingSeconds;

  /// Total seconds the timer was set to.
  int get totalSeconds => _totalSeconds;

  /// Whether the timer is currently counting down.
  bool get isRunning => _isRunning;

  /// Returns the remaining time formatted as MM:SS.
  String get formattedRemaining {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Progress from 0.0 (full) to 1.0 (done).
  double get progress {
    if (_totalSeconds == 0) return 0.0;
    return 1.0 - (_remainingSeconds / _totalSeconds);
  }

  /// Sets the timer duration without starting it.
  void setDuration(int seconds) {
    _totalSeconds = seconds;
    _remainingSeconds = seconds;
  }

  /// Starts the countdown timer.
  ///
  /// [onTick] is called every second with the remaining seconds.
  /// [onComplete] is called when the timer reaches zero.
  void start({
    required TimerTickCallback onTick,
    required TimerCompleteCallback onComplete,
  }) {
    if (_remainingSeconds <= 0) return;
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      onTick(_remainingSeconds);
      if (_remainingSeconds <= 0) {
        _isRunning = false;
        timer.cancel();
        onComplete();
      }
    });
  }

  /// Pauses the timer without resetting.
  void pause() {
    _isRunning = false;
    _timer?.cancel();
  }

  /// Resets the timer to the total duration.
  void reset() {
    _isRunning = false;
    _timer?.cancel();
    _remainingSeconds = _totalSeconds;
  }

  /// Stops and clears the timer completely.
  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _remainingSeconds = 0;
    _totalSeconds = 0;
  }

  /// Disposes the timer resources.
  void dispose() {
    _timer?.cancel();
  }
}
