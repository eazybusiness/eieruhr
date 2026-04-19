import 'package:flutter_test/flutter_test.dart';
import 'package:eieruhr/services/foreground_service.dart';

void main() {
  group('ForegroundService', () {
    late ForegroundService service;

    setUp(() {
      service = ForegroundService();
    });

    test('should be a singleton', () {
      final service1 = ForegroundService();
      final service2 = ForegroundService();
      expect(service1, same(service2));
    });

    test('should not be running initially', () {
      expect(service.isRunning, isFalse);
    });

    test('init should not throw', () {
      expect(() => service.init(), returnsNormally);
    });

    test('onTimerComplete should be null initially', () {
      expect(service.onTimerComplete, isNull);
    });
  });
}
