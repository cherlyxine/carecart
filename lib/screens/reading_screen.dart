part of '../app/carecart_root.dart';

extension _ReadingScreen on _CareCartRootState {
  Widget _reading() => _scroll([
    _heading('Blood pressure', 'Your saved reading',
        measured ? 'Your own measurement is saved on this device.' :
            'No measurement has been saved yet.'),
    if (measured)
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: accessibility['Higher contrast'] == true ? Colors.black : forest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: [
          Text('$systolic / $diastolic', style: const TextStyle(
              fontSize: 48, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Systolic / Diastolic',
              style: TextStyle(color: Colors.white, fontSize: 17)),
          const SizedBox(height: 14),
          const Text('Saved on this device',
              style: TextStyle(color: Colors.white)),
        ]),
      ),
    const SizedBox(height: 18),
    const Text('CareCart does not diagnose or automatically share readings with your care team.'),
    const SizedBox(height: 24),
    _button('Record another reading', _enterBloodPressure,
        outlined: true, icon: Icons.edit_note),
    const SizedBox(height: 10),
    _button('Done', () => open('finished'), icon: Icons.check),
  ]);
}
