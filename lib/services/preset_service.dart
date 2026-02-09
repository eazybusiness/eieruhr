import 'package:shared_preferences/shared_preferences.dart';
import '../models/timer_preset.dart';

/// Service for persisting and loading timer presets via SharedPreferences.
class PresetService {
  static const String _presetsKey = 'timer_presets';

  /// Default presets shipped with the app.
  static final List<TimerPreset> defaultPresets = [
    TimerPreset.fromMinutesSeconds(name: 'Eier', minutes: 6, seconds: 20),
    TimerPreset.fromMinutesSeconds(name: 'Brot', minutes: 30, seconds: 0),
  ];

  /// Loads all saved presets. Returns default presets if none are saved.
  Future<List<TimerPreset>> loadPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_presetsKey);
    if (jsonString == null || jsonString.isEmpty) {
      // Reason: First launch – save and return defaults.
      await savePresets(defaultPresets);
      return List.from(defaultPresets);
    }
    return TimerPreset.decodeList(jsonString);
  }

  /// Saves the given list of presets to SharedPreferences.
  Future<void> savePresets(List<TimerPreset> presets) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_presetsKey, TimerPreset.encodeList(presets));
  }

  /// Adds a new preset and persists the updated list.
  Future<List<TimerPreset>> addPreset(TimerPreset preset) async {
    final presets = await loadPresets();
    presets.add(preset);
    await savePresets(presets);
    return presets;
  }

  /// Removes a preset by index and persists the updated list.
  Future<List<TimerPreset>> removePreset(int index) async {
    final presets = await loadPresets();
    if (index >= 0 && index < presets.length) {
      presets.removeAt(index);
      await savePresets(presets);
    }
    return presets;
  }

  /// Updates a preset at the given index and persists the updated list.
  Future<List<TimerPreset>> updatePreset(int index, TimerPreset preset) async {
    final presets = await loadPresets();
    if (index >= 0 && index < presets.length) {
      presets[index] = preset;
      await savePresets(presets);
    }
    return presets;
  }
}
