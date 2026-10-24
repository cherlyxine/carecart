part of '../app/carecart_root.dart';

extension _TodayScreen on _CareCartRootState {
  Widget _today() => _scroll([
    _heading('Today', 'Hello, ${name.split(' ').first}', ''),
    Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.favorite_border, color: forest, size: 36),
          const SizedBox(height: 14),
          const Text("TODAY'S CARE", style: TextStyle(
              fontWeight: FontWeight.bold, letterSpacing: 1.5, color: forest)),
          const SizedBox(height: 8),
          Text(measured ? 'Blood pressure recorded' : 'Check your blood pressure',
              style: const TextStyle(fontFamily: 'Georgia', fontSize: 25)),
          const SizedBox(height: 8),
          Text(measured ? 'Last saved reading: $systolic / $diastolic' :
              'Enter your blood pressure reading.'),
          const SizedBox(height: 18),
          _button(measured ? 'Record another reading' : 'Start',
              () => open('guidance'), icon: Icons.favorite_outline),
        ]),
      ),
    ),
  ]);
}
