import 'dart:convert';

/// Represents a saved timer preset with a name and duration.
class TimerPreset {
  /// Display name of the preset (e.g., "Eier", "Brot").
  final String name;

  /// Duration in seconds.
  final int durationSeconds;

  /// Creates a [TimerPreset] with the given [name] and [durationSeconds].
  const TimerPreset({
    required this.name,
    required this.durationSeconds,
  });

  /// Creates a [TimerPreset] from minutes and seconds.
  factory TimerPreset.fromMinutesSeconds({
    required String name,
    required int minutes,
    required int seconds,
  }) {
    return TimerPreset(
      name: name,
      durationSeconds: minutes * 60 + seconds,
    );
  }

  /// Returns the duration formatted as MM:SS.
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Returns the minutes component of the duration.
  int get minutes => durationSeconds ~/ 60;

  /// Returns the seconds component of the duration.
  int get seconds => durationSeconds % 60;

  /// Serializes this preset to a JSON map.
  Map<String, dynamic> toJson() => {
        'name': name,
        'durationSeconds': durationSeconds,
      };

  /// Deserializes a [TimerPreset] from a JSON map.
  factory TimerPreset.fromJson(Map<String, dynamic> json) {
    return TimerPreset(
      name: json['name'] as String,
      durationSeconds: json['durationSeconds'] as int,
    );
  }

  /// Serializes a list of presets to a JSON string.
  static String encodeList(List<TimerPreset> presets) {
    return jsonEncode(presets.map((p) => p.toJson()).toList());
  }

  /// Deserializes a list of presets from a JSON string.
  static List<TimerPreset> decodeList(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => TimerPreset.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerPreset &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          durationSeconds == other.durationSeconds;

  @override
  int get hashCode => name.hashCode ^ durationSeconds.hashCode;

  @override
  String toString() => 'TimerPreset(name: $name, duration: $formattedDuration)';
}
