import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eieruhr/widgets/countdown_display.dart';

void main() {
  group('CountdownDisplay', () {
    // Helper to wrap widget in MaterialApp for testing.
    Widget buildTestWidget({
      String timeText = '00:00',
      double progress = 0.0,
      bool isRunning = false,
      bool isAlarmRinging = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CountdownDisplay(
              timeText: timeText,
              progress: progress,
              isRunning: isRunning,
              isAlarmRinging: isAlarmRinging,
            ),
          ),
        ),
      );
    }

    // Expected use: displays the time text.
    testWidgets('should display the time text', (tester) async {
      await tester.pumpWidget(buildTestWidget(timeText: '06:20'));
      expect(find.text('06:20'), findsOneWidget);
    });

    // Edge case: displays zero time.
    testWidgets('should display 00:00 when no time set', (tester) async {
      await tester.pumpWidget(buildTestWidget(timeText: '00:00'));
      expect(find.text('00:00'), findsOneWidget);
    });

    // Expected use: renders without errors when alarm is ringing.
    testWidgets('should render when alarm is ringing', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        timeText: '00:00',
        progress: 1.0,
        isAlarmRinging: true,
      ));
      expect(find.text('00:00'), findsOneWidget);
    });

    // Failure case: widget builds with extreme progress values.
    testWidgets('should handle progress at boundaries', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        timeText: '30:00',
        progress: 0.0,
        isRunning: false,
      ));
      expect(find.text('30:00'), findsOneWidget);

      await tester.pumpWidget(buildTestWidget(
        timeText: '00:00',
        progress: 1.0,
        isRunning: false,
      ));
      expect(find.text('00:00'), findsOneWidget);
    });
  });
}
