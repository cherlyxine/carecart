part of '../app/carecart_root.dart';

extension _GuidanceScreen on _CareCartRootState {
  Future<void> _enterBloodPressure() async {
    final reading = await Navigator.of(context).push<(int, int)>(
      MaterialPageRoute(builder: (_) => const BloodPressureEntryScreen()),
    );
    if (!mounted || reading == null) return;
    _update(() {
      systolic = reading.$1.toString();
      diastolic = reading.$2.toString();
      measured = true;
      final taskIndex = tasks.indexOf('Check blood pressure');
      if (taskIndex >= 0) completed.add(taskIndex);
    });
    open('reading');
  }

  Widget _guidance() => _scroll([
    _heading('Your care step', 'Check your blood pressure',
        'Use your own blood pressure monitor.'),
    const Text('Instructions', style: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    _instructionStep('1. Sit down and rest',
        'Sit quietly for five minutes before measuring.'),
    _instructionStep('2. Put on the cuff',
        'Follow the positioning instructions provided with your monitor.'),
    _instructionStep('3. Take a reading',
        'Use your monitor and note its two numbers.'),
    const SizedBox(height: 14),
    _button('Enter my blood pressure result', _enterBloodPressure,
        icon: Icons.edit_note),
  ]);

  Widget _instructionStep(String title, String description) => Card(
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(
            fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(fontSize: 17)),
      ]),
    ),
  );
}
