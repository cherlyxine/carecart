part of 'carecart_root.dart';

extension _CareDialogs on _CareCartRootState {
  Future<void> _message(String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('CareCart'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _addNote() async {
    String draft = '';
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add a note'),
        content: TextFormField(
          autofocus: true,
          maxLines: 3,
          onChanged: (value) => draft = value,
          decoration: const InputDecoration(
            hintText: 'What would you like to remember?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(draft.trim()),
            child: const Text('Save note'),
          ),
        ],
      ),
    );
    if (!mounted || result == null || result.isEmpty) return;
    _update(() => notes.add(result));
  }

  Future<void> _editName() async {
    String draft = name;
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('My details'),
        content: TextFormField(
          initialValue: name,
          onChanged: (value) => draft = value,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(draft.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (!mounted || result == null || result.isEmpty) return;
    _update(() => name = result);
  }

  Future<void> _addMedicine() async {
    final medicine = await Navigator.of(context).push<Medicine>(
      MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
    );
    if (!mounted || medicine == null) return;
    _update(() => medicines.insert(0, medicine));
  }

  Future<void> _addAppointment() async {
    final appointment = await Navigator.of(context).push<Appointment>(
      MaterialPageRoute(builder: (_) => const AddAppointmentScreen()),
    );
    if (!mounted || appointment == null) return;
    _update(() => appointments.insert(0, appointment));
  }
}
