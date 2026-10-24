part of '../app/carecart_root.dart';

extension _HealthScreen on _CareCartRootState {
  Widget _health() => _scroll([
    _heading('Aisle 1', 'My health',
        'A simple view of health information you saved on this device.'),
    const Text('Blood pressure', style: TextStyle(
        fontSize: 23, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    Card(color: Colors.white, child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(measured ? '$systolic / $diastolic' : 'No reading saved yet',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(measured ? 'Your most recent saved reading' :
            'Enter a measurement from your own monitor.'),
        const SizedBox(height: 16),
        _button(measured ? 'Record another reading' : 'Record a reading',
            _enterBloodPressure, icon: Icons.edit_note),
      ]),
    )),
    const SizedBox(height: 20),
    const Text('Things to discuss with my doctor',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    for (final note in notes) Card(color: Colors.white,
      child: Padding(padding: const EdgeInsets.all(16), child: Text(note))),
    _button('Add a note', _addNote, icon: Icons.add),
  ]);
}
