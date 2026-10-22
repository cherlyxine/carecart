part of '../app/carecart_root.dart';

extension _HelpScreen on _CareCartRootState {
  Widget _help() => _scroll([
    const SizedBox(height: 15), const Center(child: Icon(Icons.headset_mic_outlined, size: 90, color: forest)), const SizedBox(height: 18),
    _heading('Help desk', 'How can we help?', 'Asking for help is always okay. Choose what you need.'),
    Card(color: gold, child: const Padding(padding: EdgeInsets.all(16), child: Text('CareCart shows one care step at a time. Today shows what to do now. Your Basket keeps your care plan. Aisles help you find information.'))),
    const SizedBox(height: 12), _tile('Explain this to me', 'Use simpler words', Icons.lightbulb_outline, () => _message('Today shows your next step. Basket lists your tasks. Aisles contain your health information.')),
    _tile('Read this aloud', 'Listen instead of reading', Icons.volume_up_outlined, () => _message('Audio playback is not yet connected. This is a prototype.')),
    _tile('Make CareCart easier', 'Accessibility settings', Icons.auto_awesome, () => open('accessibility')),
  ]);
}
