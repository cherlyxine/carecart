part of '../app/carecart_root.dart';

extension _TodayScreen on _CareCartRootState {
  Widget _today() => _scroll([
    _heading('Today', 'Good morning, ${name.split(' ').first}', 'You have one thing to do today.'),
    Card(color: Colors.white, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.favorite_border, color: forest, size: 34), const SizedBox(height: 18),
      const Text("TODAY'S CARE", style: TextStyle(fontSize: 10, letterSpacing: 2, color: forest)),
      const SizedBox(height: 8), const Text('Check your blood pressure', style: TextStyle(fontFamily: 'Georgia', fontSize: 24)),
      const SizedBox(height: 8), const Text("Take your time. We'll guide you."), const SizedBox(height: 18),
      _button('Start', () => open('guidance'), icon: Icons.arrow_forward),
      const Divider(height: 26), const Text('About 5 minutes                                 Step 1 of 1', style: TextStyle(fontSize: 12)),
    ]))),
    const SizedBox(height: 14),
    _tile('Make it easier', 'Change text and accessibility settings', Icons.auto_awesome, () => open('accessibility')),
    _tile('Different situation today', 'Choose a smaller alternative', Icons.favorite_outline, () => _message('You can go at your own pace. Try again when you are ready.')),
    _tile('Why this step?', 'Learn about blood pressure', Icons.info_outline, () => open('guidance')),
  ]);
}
