part of '../app/carecart_root.dart';

extension _FinishedScreen on _CareCartRootState {
  Widget _finished() => _scroll([
    const SizedBox(height: 50), const Center(child: Icon(Icons.task_alt, color: forest, size: 100)),
    const SizedBox(height: 24), const Center(child: Text("You're done for today.", style: TextStyle(fontFamily: 'Georgia', fontSize: 30))),
    const SizedBox(height: 14), const Center(child: Text('Your care step has been saved. Take the rest of the day at your own pace.', textAlign: TextAlign.center)),
    const SizedBox(height: 24), _tile('Your next care step', 'Take morning medicine · Tomorrow', Icons.calendar_today_outlined, () => goTab(1)),
    _button('View my basket', () => goTab(1), icon: Icons.shopping_basket_outlined),
  ]);
}
