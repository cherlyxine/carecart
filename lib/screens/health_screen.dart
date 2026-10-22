part of '../app/carecart_root.dart';

extension _HealthScreen on _CareCartRootState {
  Widget _health() => _scroll([
    _heading('Aisle 1', 'My health', 'A simple view of your recent health information.'),
    const Text('Recent measurements', style: TextStyle(fontFamily: 'Georgia', fontSize: 21)), const SizedBox(height: 12),
    _tile('Blood pressure', measured ? '$systolic / $diastolic · Saved' : '128 / 78 · Sample reading', Icons.favorite_border, () => open('reading')),
    const SizedBox(height: 8), const Text('Things to discuss with my doctor', style: TextStyle(fontFamily: 'Georgia', fontSize: 21)),
    const SizedBox(height: 10), for (final note in notes) _tile(note, '', Icons.notes, () {}),
    _button('Add a note', () => _addNote(), icon: Icons.add),
  ]);
}
