import 'package:flutter/material.dart';
import '../models/care_models.dart';
import '../theme/app_colors.dart';

/// An independent form: chooses date and time using native Flutter pickers.
/// Returns an Appointment to the calling screen when saved.
class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _place = TextEditingController();
  final _doctor = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _doctor.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final now = DateTime.now();
    final choice = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
      helpText: 'Select appointment date',
    );
    if (!mounted || choice == null) return;
    setState(() => _date = choice);
  }

  Future<void> _chooseTime() async {
    final choice = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
      helpText: 'Select appointment time',
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (!mounted || choice == null) return;
    setState(() => _time = choice);
  }

  String _dateText(DateTime value) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${value.day} ${months[value.month - 1]} ${value.year}';
  }

  String _timeText(TimeOfDay value) =>
      '${value.hour.toString().padLeft(2,'0')}:${value.minute.toString().padLeft(2,'0')}';

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both a date and a time.')),
      );
      return;
    }
    Navigator.of(context).pop(Appointment(
      _title.text.trim(),
      _dateText(_date!),
      _timeText(_time!),
      _place.text.trim(),
      _doctor.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: cream,
    appBar: AppBar(title: const Text('Add an appointment'), backgroundColor: cream),
    body: SafeArea(child: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Appointment name',
              border: OutlineInputBorder()),
            validator: (text) => text == null || text.trim().isEmpty
                ? 'Please enter an appointment name' : null,
          ),
          const SizedBox(height: 18),
          Card(color: Colors.white, child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: const Icon(Icons.calendar_month_outlined, color: forest, size: 30),
            title: const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_date == null ? 'Choose from calendar' : _dateText(_date!)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _chooseDate,
          )),
          const SizedBox(height: 10),
          Card(color: Colors.white, child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: const Icon(Icons.access_time_outlined, color: forest, size: 30),
            title: const Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_time == null ? 'Choose a time' : _timeText(_time!)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _chooseTime,
          )),
          const SizedBox(height: 18),
          TextFormField(controller: _place,
            decoration: const InputDecoration(labelText: 'Place',
              border: OutlineInputBorder())),
          const SizedBox(height: 14),
          TextFormField(controller: _doctor,
            decoration: const InputDecoration(labelText: 'Doctor or practitioner',
              border: OutlineInputBorder())),
          const SizedBox(height: 24),
          SizedBox(height: 54, child: FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: const Text('Save appointment'),
          )),
          const SizedBox(height: 10),
          SizedBox(height: 52, child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          )),
        ],
      ),
    )),
  );
}
