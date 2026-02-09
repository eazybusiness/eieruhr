import 'package:flutter/material.dart';
import 'screens/timer_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EieruhrApp());
}

/// Root widget of the Eieruhr app.
class EieruhrApp extends StatelessWidget {
  const EieruhrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eieruhr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const TimerScreen(),
    );
  }
}
