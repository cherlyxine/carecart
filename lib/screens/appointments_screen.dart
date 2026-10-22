part of '../app/carecart_root.dart';

extension _AppointmentsScreen on _CareCartRootState {
  Widget _appointments() => _scroll([
    _heading('Aisle 3', 'My appointments', '${appointments.where((a) => !a.attended).length} upcoming appointments.'),
    _button('Add an appointment', _addAppointment, icon: Icons.calendar_month_outlined), const SizedBox(height: 16),
    for (final a in appointments) Card(color: forest, margin: const EdgeInsets.only(bottom: 14), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('${a.date} · ${a.time}', style: const TextStyle(color: gold, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), Text(a.name, style: const TextStyle(fontFamily: 'Georgia', fontSize: 25, color: Colors.white)),
      Text('${a.place}\n${a.doctor}', style: const TextStyle(color: Colors.white70)), const SizedBox(height: 14),
      _button(a.attended ? '✓ Attended' : 'Mark as attended', () => _update(() => a.attended = !a.attended), outlined: true),
    ]))),
  ]);
}
