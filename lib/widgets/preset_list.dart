import 'package:flutter/material.dart';
import '../models/timer_preset.dart';

/// Displays a horizontal list of preset chips that can be tapped to select.
class PresetList extends StatelessWidget {
  /// The list of presets to display.
  final List<TimerPreset> presets;

  /// Called when a preset is tapped.
  final void Function(TimerPreset preset) onPresetTap;

  /// Called when a preset is long-pressed (for deletion).
  final void Function(int index)? onPresetLongPress;

  /// The currently selected preset index, if any.
  final int? selectedIndex;

  const PresetList({
    super.key,
    required this.presets,
    required this.onPresetTap,
    this.onPresetLongPress,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (presets.isEmpty) {
      return const Center(
        child: Text(
          'Keine Voreinstellungen vorhanden.\nTippe + um eine hinzuzufügen.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(presets.length, (index) {
        final preset = presets[index];
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onLongPress: () => onPresetLongPress?.call(index),
          child: ChoiceChip(
            label: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  preset.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  preset.formattedDuration,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            selected: isSelected,
            onSelected: (_) => onPresetTap(preset),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        );
      }),
    );
  }
}
