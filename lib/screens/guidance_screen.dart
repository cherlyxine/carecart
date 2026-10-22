part of '../app/carecart_root.dart';

extension _GuidanceScreen on _CareCartRootState {
  Widget _guidance() => _scroll([
    _heading('Your care step', 'Check your blood pressure', 'Take a reading with your blood pressure monitor.'),
    _tile('1. Sit down and rest', 'Rest for five minutes before measuring.', Icons.chair_outlined, () {}),
    _tile('2. Put on the cuff', 'Place the cuff on your upper arm.', Icons.favorite_outline, () {}),
    _tile('3. Take a reading', 'Follow the instructions from your monitor.', Icons.monitor_heart_outlined, () {}),
    const SizedBox(height: 12),
    const Text('Top number (systolic)'), const SizedBox(height: 5),
    TextFormField(initialValue: systolic, keyboardType: TextInputType.number, onChanged: (v) => systolic = v),
    const SizedBox(height: 14), const Text('Bottom number (diastolic)'), const SizedBox(height: 5),
    TextFormField(initialValue: diastolic, keyboardType: TextInputType.number, onChanged: (v) => diastolic = v),
    const SizedBox(height: 20), _button('Save my reading', () { _update(() { measured = true; completed.add(0); }); open('reading'); }),
  ]);
}
