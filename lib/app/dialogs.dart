part of 'carecart_root.dart';

extension _CareDialogs on _CareCartRootState {
  Future<void> _message(String message) async => showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: const Text('CareCart'), content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))]));
  Future<void> _addNote() async {
    final controller = TextEditingController();
    await showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: const Text('Add a note'), content: TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(hintText: 'What would you like to remember?')), actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      FilledButton(onPressed: () { if (controller.text.trim().isNotEmpty) _update(() => notes.add(controller.text.trim())); Navigator.pop(ctx); }, child: const Text('Save note')),
    ])); controller.dispose();
  }
  Future<void> _editName() async {
    final controller = TextEditingController(text: name);
    await showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: const Text('My details'), content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Name')), actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      FilledButton(onPressed: () { if (controller.text.trim().isNotEmpty) _update(() => name = controller.text.trim()); Navigator.pop(ctx); }, child: const Text('Save')),
    ])); controller.dispose();
  }
  Future<void> _addMedicine() async {
    final controllers = List.generate(4, (_) => TextEditingController());
    await showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: const Text('New medicine'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      for (int i=0;i<4;i++) Padding(padding: const EdgeInsets.only(bottom: 10), child: TextField(controller: controllers[i], maxLines: i==3 ? 2 : 1, decoration: InputDecoration(labelText: ['Medicine name', 'Dose', 'When to take it', 'Instructions'][i]))),
    ])), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      FilledButton(onPressed: () { if (controllers[0].text.trim().isNotEmpty) {_update(() => medicines.insert(0, Medicine(controllers[0].text.trim(), controllers[1].text, controllers[2].text, controllers[3].text))); Navigator.pop(ctx);} }, child: const Text('Save medicine')),
    ])); for (final c in controllers) { c.dispose(); }
  }
  Future<void> _addAppointment() async {
    final controllers = List.generate(5, (_) => TextEditingController());
    await showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: const Text('New appointment'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      for (int i=0;i<5;i++) Padding(padding: const EdgeInsets.only(bottom: 10), child: TextField(controller: controllers[i], decoration: InputDecoration(labelText: ['Appointment name', 'Date (e.g. 15 May)', 'Time', 'Place', 'Doctor or practitioner'][i]))),
    ])), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      FilledButton(onPressed: () { if (controllers[0].text.trim().isNotEmpty) {_update(() => appointments.insert(0, Appointment(controllers[0].text.trim(), controllers[1].text, controllers[2].text, controllers[3].text, controllers[4].text))); Navigator.pop(ctx);} }, child: const Text('Save appointment')),
    ])); for (final c in controllers) { c.dispose(); }
  }
}
