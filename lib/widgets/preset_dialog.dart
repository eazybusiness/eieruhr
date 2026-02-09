import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/timer_preset.dart';

/// Dialog for adding or editing a timer preset.
class PresetDialog extends StatefulWidget {
  /// Existing preset to edit, or null for a new preset.
  final TimerPreset? existingPreset;

  const PresetDialog({super.key, this.existingPreset});

  @override
  State<PresetDialog> createState() => _PresetDialogState();
}

class _PresetDialogState extends State<PresetDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existingPreset?.name ?? '');
    _minutesController = TextEditingController(
        text: widget.existingPreset?.minutes.toString() ?? '');
    _secondsController = TextEditingController(
        text: widget.existingPreset?.seconds.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  /// Validates input and returns the preset if valid.
  TimerPreset? _buildPreset() {
    final name = _nameController.text.trim();
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;

    if (name.isEmpty) return null;
    if (minutes == 0 && seconds == 0) return null;

    return TimerPreset.fromMinutesSeconds(
      name: name,
      minutes: minutes,
      seconds: seconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingPreset != null;
    return AlertDialog(
      title: Text(isEditing ? 'Voreinstellung bearbeiten' : 'Neue Voreinstellung'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'z.B. Eier, Brot, Tee',
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minutesController,
                  decoration: const InputDecoration(
                    labelText: 'Minuten',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(':', style: TextStyle(fontSize: 24)),
              ),
              Expanded(
                child: TextField(
                  controller: _secondsController,
                  decoration: const InputDecoration(
                    labelText: 'Sekunden',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () {
            final preset = _buildPreset();
            if (preset != null) {
              Navigator.of(context).pop(preset);
            }
          },
          child: Text(isEditing ? 'Speichern' : 'Hinzufügen'),
        ),
      ],
    );
  }
}
