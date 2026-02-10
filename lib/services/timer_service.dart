import 'dart:async';

/// Callback type for timer tick events.
typedef TimerTickCallback = void Function(int remainingSeconds);

/// Callback type for timer completion.
typedef TimerCompleteCallback = void Function();

/// Service that manages the countdown timer logic.
///
/// Uses [DateTime]-based end-time tracking so the countdown survives
/// the app being in the background or the screen being off.
class TimerService {
  Timer? _timer;
  int _totalSeconds = 0;
  bool _isRunning = false;

  /// The wall-clock time when the timer will reach zero.
  /// Only set while the timer is running.
  DateTime? _endTime;

  /// Stored remaining seconds used when the timer is NOT running.
  int _storedRemaining = 0;

  /// Current remaining seconds on the timer.
  int get remainingSeconds {
    if (_endTime != null) {
      final remaining = _endTime!.difference(DateTime.now()).inSeconds;
      return remaining < 0 ? 0 : remaining;
    }
    return _storedRemaining;
  }

  /// Total seconds the timer was set to.
  int get totalSeconds => _totalSeconds;

  /// Whether the timer is currently counting down.
  bool get isRunning => _isRunning;

  /// The scheduled end time (used by NotificationService to schedule alarm).
  DateTime? get endTime => _endTime;

  /// Returns the remaining time formatted as MM:SS.
  String get formattedRemaining {
    final secs = remainingSeconds;
    final minutes = secs ~/ 60;
    final seconds = secs % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// Progress from 0.0 (full) to 1.0 (done).
  double get progress {
    if (_totalSeconds == 0) return 0.0;
    return 1.0 - (remainingSeconds / _totalSeconds);
  }

  /// Sets the timer duration without starting it.
  void setDuration(int seconds) {
    _totalSeconds = seconds;
    _storedRemaining = seconds;
    _endTime = null;
  }

  /// Starts the countdown timer.
  ///
  /// [onTick] is called every second with the remaining seconds.
  /// [onComplete] is called when the timer reaches zero.
  void start({
    required TimerTickCallback onTick,
    required TimerCompleteCallback onComplete,
  }) {
    if (_storedRemaining <= 0 && _endTime == null) return;
    _isRunning = true;
    // Reason: Compute end time from stored remaining seconds.
    _endTime = DateTime.now().add(Duration(seconds: _storedRemaining));
    _timer?.cancel();

    // Reason: Timer.periodic drives UI updates while the app is in the
    // foreground.  The actual remaining time is always derived from
    // DateTime.now() vs _endTime, so even if ticks are delayed the
    // displayed value stays correct.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = remainingSeconds;
      onTick(remaining);
      if (remaining <= 0) {
        _isRunning = false;
        timer.cancel();
        onComplete();
      }
    });
  }

  /// Pauses the timer.
  void pause() {
    _isRunning = false;
    _timer?.cancel();
    // Reason: Freeze the remaining duration so we can resume later.
    _storedRemaining = remainingSeconds;
    _endTime = null;
  }

  /// Resets the timer to the total duration.
  void reset() {
    _isRunning = false;
    _timer?.cancel();
    _storedRemaining = _totalSeconds;
    _endTime = null;
  }

  /// Stops and clears the timer completely.
  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _totalSeconds = 0;
    _storedRemaining = 0;
    _endTime = null;
  }

  /// Called when the app resumes from background.
  ///
  /// Re-derives state from [_endTime].  If the timer has already
  /// elapsed, calls [onComplete].
  void syncFromBackground({
    required TimerTickCallback onTick,
    required TimerCompleteCallback onComplete,
  }) {
    if (!_isRunning || _endTime == null) return;

    final remaining = remainingSeconds;
    if (remaining <= 0) {
      _isRunning = false;
      _timer?.cancel();
      onComplete();
    } else {
      // Restart the periodic tick so the UI keeps updating.
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final r = remainingSeconds;
        onTick(r);
        if (r <= 0) {
          _isRunning = false;
          timer.cancel();
          onComplete();
        }
      });
    }
  }

  /// Disposes the timer resources.
  void dispose() {
    _timer?.cancel();
  }
}
