part of '../app/carecart_root.dart';

extension _AppointmentsScreen on _CareCartRootState {
  Future<void> _deleteAppointment(Appointment appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete appointment?'),
        content: Text('Remove "${appointment.name}" from your appointments?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    _update(() => appointments.remove(appointment));
  }

  Widget _appointments() => _scroll([
    _heading('Aisle 3', 'My appointments',
        '${appointments.where((a) => !a.attended).length} upcoming appointments.'),
    _button('Add an appointment', _addAppointment,
        icon: Icons.calendar_month_outlined),
    const SizedBox(height: 16),
    if (appointments.isEmpty)
      const Card(child: Padding(
        padding: EdgeInsets.all(20),
        child: Text('No appointments yet. Tap Add an appointment to get started.'),
      )),
    for (final appointment in appointments)
      Card(
        color: forest,
        margin: const EdgeInsets.only(bottom: 14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${appointment.date} · ${appointment.time}',
                style: const TextStyle(color: gold, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(appointment.name, style: const TextStyle(
                fontFamily: 'Georgia', fontSize: 25, color: Colors.white)),
              const SizedBox(height: 6),
              Text('${appointment.place}\n${appointment.doctor}',
                style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: forest,
                  ),
                  onPressed: () => _update(() =>
                      appointment.attended = !appointment.attended),
                  icon: Icon(appointment.attended
                      ? Icons.check_circle : Icons.check_circle_outline),
                  label: Text(appointment.attended
                      ? 'Attended · Undo' : 'Mark as attended'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70, width: 1.5),
                  ),
                  onPressed: () => _deleteAppointment(appointment),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete appointment'),
                ),
              ),
            ],
          ),
        ),
      ),
  ]);
}
