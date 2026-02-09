import 'package:flutter_test/flutter_test.dart';
import 'package:eieruhr/models/timer_preset.dart';

void main() {
  group('TimerPreset', () {
    // Expected use: create a preset and check properties.
    test('should create preset with correct duration', () {
      const preset = TimerPreset(name: 'Eier', durationSeconds: 380);
      expect(preset.name, 'Eier');
      expect(preset.durationSeconds, 380);
      expect(preset.minutes, 6);
      expect(preset.seconds, 20);
      expect(preset.formattedDuration, '06:20');
    });

    // Expected use: factory constructor from minutes and seconds.
    test('fromMinutesSeconds should calculate correct total seconds', () {
      final preset = TimerPreset.fromMinutesSeconds(
        name: 'Brot',
        minutes: 30,
        seconds: 0,
      );
      expect(preset.durationSeconds, 1800);
      expect(preset.formattedDuration, '30:00');
    });

    // Edge case: zero duration.
    test('should handle zero duration', () {
      const preset = TimerPreset(name: 'Zero', durationSeconds: 0);
      expect(preset.minutes, 0);
      expect(preset.seconds, 0);
      expect(preset.formattedDuration, '00:00');
    });

    // Edge case: large duration.
    test('should handle large duration correctly', () {
      const preset = TimerPreset(name: 'Long', durationSeconds: 5999);
      expect(preset.minutes, 99);
      expect(preset.seconds, 59);
      expect(preset.formattedDuration, '99:59');
    });

    // JSON serialization round-trip.
    test('should serialize and deserialize to/from JSON', () {
      const original = TimerPreset(name: 'Tee', durationSeconds: 180);
      final json = original.toJson();
      final restored = TimerPreset.fromJson(json);
      expect(restored, original);
      expect(restored.name, 'Tee');
      expect(restored.durationSeconds, 180);
    });

    // List encoding/decoding round-trip.
    test('should encode and decode a list of presets', () {
      final presets = [
        const TimerPreset(name: 'Eier', durationSeconds: 380),
        const TimerPreset(name: 'Brot', durationSeconds: 1800),
      ];
      final encoded = TimerPreset.encodeList(presets);
      final decoded = TimerPreset.decodeList(encoded);
      expect(decoded.length, 2);
      expect(decoded[0], presets[0]);
      expect(decoded[1], presets[1]);
    });

    // Failure case: equality check with different values.
    test('should not be equal if name or duration differs', () {
      const a = TimerPreset(name: 'Eier', durationSeconds: 380);
      const b = TimerPreset(name: 'Eier', durationSeconds: 400);
      const c = TimerPreset(name: 'Brot', durationSeconds: 380);
      expect(a == b, false);
      expect(a == c, false);
    });
  });
}
