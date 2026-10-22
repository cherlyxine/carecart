part of '../app/carecart_root.dart';

extension _MedicinesScreen on _CareCartRootState {
  Widget _medicines() => _scroll([
    _heading('Aisle 2', 'My medicines', 'See what to take and when. Always follow the instructions from your care team.'),
    _button('Add a medicine', _addMedicine, icon: Icons.medication_outlined), const SizedBox(height: 16),
    for (final medicine in medicines) Card(color: Colors.white, margin: const EdgeInsets.only(bottom: 12), child: ExpansionTile(
      leading: const Icon(Icons.medication_outlined, color: forest), title: Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      childrenPadding: const EdgeInsets.all(12), children: [
        Align(alignment: Alignment.centerLeft, child: Text('${medicine.dose}\n${medicine.time}')),
        const SizedBox(height: 10), _button(medicine.taken ? 'Taken ✓' : 'Mark as taken', () => _update(() { medicine.taken = !medicine.taken; if (medicine.taken) completed.add(1); }), outlined: true),
        TextButton(onPressed: () => _message(medicine.instructions.isEmpty ? 'Follow your care team instructions.' : medicine.instructions), child: const Text('How to take it ›')),
        TextButton(onPressed: () => _update(() => medicines.remove(medicine)), child: const Text('Remove medicine', style: TextStyle(color: Colors.redAccent))),
      ],
    )),
  ]);
}
