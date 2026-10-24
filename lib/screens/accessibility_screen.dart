part of '../app/carecart_root.dart';

extension _AccessibilityScreen on _CareCartRootState {
  Widget _accessibility() => _scroll([
    _heading('Accessibility', 'Make CareCart easier',
        'Choose what makes CareCart more comfortable for you.'),
    Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Text size', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
          const SizedBox(height: 10),
          Text('Preview: Read your care tasks easily',
              style: TextStyle(fontSize: 17 * textScale)),
          const SizedBox(height: 8),
          Text('${(textScale * 100).round()}% of normal size',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Slider(
            min: 1.0,
            max: 2.0,
            divisions: 10,
            value: textScale.clamp(1.0, 2.0),
            label: '${(textScale * 100).round()}%',
            onChanged: (value) => _update(() {
              textScale = value;
              accessibility['Larger text'] = value > 1.0;
            }),
          ),
          const Text('Drag the slider to make text bigger. Up to 200%.'),
        ]),
      ),
    ),
    const SizedBox(height: 12),
    if (accessibility['Read aloud'] == true) ...[
      _button(_isSpeaking ? 'Stop reading' : 'Try reading this page',
          _toggleSpeech,
          icon: _isSpeaking ? Icons.stop_circle_outlined : Icons.volume_up_outlined),
      const SizedBox(height: 12),
    ],
    for (final entry in accessibility.entries)
      if (entry.key != 'Larger text')
        Card(
          child: SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(switch (entry.key) {
              'Read aloud' => 'Read the current page with the speaker button',
              'Higher contrast' => 'Use stronger contrast for easier reading',
              'Slow down animations' => 'Reduce motion (planned)',
              _ => 'Make notifications easier to notice (planned)',
            }),
            value: entry.value,
            onChanged: (value) {
              if (entry.key == 'Read aloud' && !value) _stopSpeech();
              _update(() => accessibility[entry.key] = value);
            },
          ),
        ),
  ]);
}
