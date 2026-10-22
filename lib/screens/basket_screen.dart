part of '../app/carecart_root.dart';

extension _BasketScreen on _CareCartRootState {
  Widget _basket() => _scroll([
    _heading('Your care plan', 'My Care Basket', 'These are the things that are part of your care plan.'),
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: mint, borderRadius: BorderRadius.circular(14)),
      child: Text('${completed.length} of ${tasks.length} done\nYou’re on track today.', style: const TextStyle(fontWeight: FontWeight.w600, color: forest))),
    const SizedBox(height: 14),
    for (int i = 0; i < tasks.length; i++) Card(color: Colors.white, child: CheckboxListTile(
      value: completed.contains(i), activeColor: forest,
      title: Text(tasks[i], style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(i == 0 ? 'Today' : i == 1 ? 'Every day at 8:00' : i == 2 ? 'For tomorrow' : 'Throughout the day'),
      onChanged: (v) => _update(() { if (v == true) {completed.add(i);} else {completed.remove(i);} }),
    )),
  ]);
}
