part of '../app/carecart_root.dart';

extension _AccessibilityScreen on _CareCartRootState {
  Widget _accessibility() => _scroll([
    _heading('Accessibility', 'Make CareCart easier', 'Choose what makes CareCart more comfortable for you.'),
    for (final entry in accessibility.entries) Card(color: Colors.white, child: SwitchListTile(
      title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(switch (entry.key) {
        'Larger text' => 'Make all words easier to read',
        'Read aloud' => 'Hear instructions spoken (planned)',
        'Higher contrast' => 'Make things stand out more (planned)',
        'Slow down animations' => 'Keep movement calm and steady',
        _ => 'Make reminders harder to miss (planned)',
      }),
      activeThumbColor: forest, value: entry.value, onChanged: (v) => _update(() => accessibility[entry.key] = v),
    )),
  ]);
}
