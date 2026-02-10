import 'package:flutter_test/flutter_test.dart';
import 'package:eieruhr/services/timer_service.dart';

void main() {
  group('TimerService', () {
    late TimerService service;

    setUp(() {
      service = TimerService();
    });

    tearDown(() {
      service.dispose();
    });

    // Expected use: set duration and check state.
    test('setDuration should set remaining and total seconds', () {
      service.setDuration(380);
      expect(service.totalSeconds, 380);
      expect(service.remainingSeconds, closeTo(380, 1));
      expect(service.isRunning, false);
      expect(service.formattedRemaining, '06:20');
    });

    // Expected use: progress calculation.
    test('progress should be 0.0 when timer has not started', () {
      service.setDuration(100);
      expect(service.progress, closeTo(0.0, 0.02));
    });

    // Edge case: progress with zero total.
    test('progress should be 0.0 when totalSeconds is 0', () {
      expect(service.progress, 0.0);
    });

    // Expected use: reset should restore to total.
    test('reset should restore remaining to total seconds', () {
      service.setDuration(300);
      service.start(
        onTick: (_) {},
        onComplete: () {},
      );
      service.pause();
      service.reset();
      expect(service.remainingSeconds, closeTo(300, 1));
      expect(service.isRunning, false);
    });

    // Expected use: stop should clear everything.
    test('stop should clear remaining and total', () {
      service.setDuration(300);
      service.stop();
      expect(service.remainingSeconds, 0);
      expect(service.totalSeconds, 0);
      expect(service.isRunning, false);
    });

    // Failure case: start with zero duration should not run.
    test('start should not run if remaining is 0', () {
      service.setDuration(0);
      service.start(
        onTick: (_) {},
        onComplete: () {},
      );
      expect(service.isRunning, false);
    });

    // Edge case: formatted remaining for single-digit values.
    test('formattedRemaining should pad single digits', () {
      service.setDuration(65);
      expect(service.formattedRemaining, '01:05');
    });

    // Expected use: start sets isRunning to true.
    test('start should set isRunning to true', () {
      service.setDuration(10);
      service.start(
        onTick: (_) {},
        onComplete: () {},
      );
      expect(service.isRunning, true);
      service.dispose();
    });

    // Expected use: pause should stop running.
    test('pause should set isRunning to false', () {
      service.setDuration(10);
      service.start(
        onTick: (_) {},
        onComplete: () {},
      );
      service.pause();
      expect(service.isRunning, false);
    });
  });
}
