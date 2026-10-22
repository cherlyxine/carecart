part of '../app/carecart_root.dart';

extension _ReadingScreen on _CareCartRootState {
  Widget _reading() => _scroll([
    _heading('Blood pressure', 'Your reading', 'Your blood pressure measurement has been saved.'),
    Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: forest, borderRadius: BorderRadius.circular(16)), child: Column(children: [
      Text('$systolic / $diastolic', style: const TextStyle(fontFamily: 'Georgia', color: Colors.white, fontSize: 51)),
      const SizedBox(height: 8), const Text('Top number           Bottom number', style: TextStyle(color: Colors.white)),
      const Divider(color: Colors.white54, height: 35), const Text('✓ Your result has been saved.', style: TextStyle(color: Colors.white)),
    ])), const SizedBox(height: 20), const Text('What does this mean?', style: TextStyle(fontFamily: 'Georgia', fontSize: 22)),
    const Text('Your care team can see this reading if you share it with them. You do not need to do anything else right now.'),
    const SizedBox(height: 20), _button('What happens next?', () => open('finished'), icon: Icons.arrow_forward),
    const SizedBox(height: 8), _button('Done', () => open('finished'), outlined: true),
  ]);
}
