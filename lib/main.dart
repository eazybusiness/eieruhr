import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/timer_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EieruhrApp());
}

/// Root widget of the Eieruhr app.
class EieruhrApp extends StatefulWidget {
  const EieruhrApp({super.key});

  @override
  State<EieruhrApp> createState() => _EieruhrAppState();
}

class _EieruhrAppState extends State<EieruhrApp> {
  static const _channel = MethodChannel('com.eieruhr.eieruhr/intent');

  String? _presetName;
  int? _presetDuration;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _readLaunchIntent();
  }

  /// Reads extras from the Android launch intent (set by the widget provider).
  Future<void> _readLaunchIntent() async {
    try {
      final result = await _channel.invokeMethod<Map>('getLaunchIntent');
      if (result != null) {
        _presetName = result['preset_name'] as String?;
        _presetDuration = result['preset_duration'] as int?;
      }
    } on PlatformException {
      // Reason: No intent extras available – normal app launch.
    }
    setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

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
      home: TimerScreen(
        initialPresetName: _presetName,
        initialPresetDuration: _presetDuration,
      ),
    );
  }
}
