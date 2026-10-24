import 'package:flutter/material.dart';

/// Independent form: no fabricated reading; only validated user input.
class BloodPressureEntryScreen extends StatefulWidget {
  const BloodPressureEntryScreen({super.key});

  @override
  State<BloodPressureEntryScreen> createState() => _BloodPressureEntryScreenState();
}

class _BloodPressureEntryScreenState extends State<BloodPressureEntryScreen> {
  final _form = GlobalKey<FormState>();
  final _systolic = TextEditingController();
  final _diastolic = TextEditingController();

  @override
  void dispose() {
    _systolic.dispose();
    _diastolic.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final n = int.tryParse((value ?? '').trim());
    if (n == null) return 'Enter a whole number from your monitor';
    if (n < 30 || n > 300) return 'Please check the number and try again';
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Record blood pressure')),
    body: SafeArea(child: Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Enter the two numbers shown on your monitor.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          TextFormField(
            controller: _systolic,
            decoration: const InputDecoration(
              labelText: 'Top number (systolic)',
              hintText: 'Top number on the display',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: _validate,
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 22),
          TextFormField(
            controller: _diastolic,
            decoration: const InputDecoration(
              labelText: 'Bottom number (diastolic)',
              hintText: 'Bottom number on the display',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: _validate,
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 20),
          const Text('These readings stay on this device. CareCart does not send them to a doctor.',
              style: TextStyle(fontSize: 15)),
          const SizedBox(height: 28),
          SizedBox(height: 58, child: FilledButton.icon(
            onPressed: () {
              if (!_form.currentState!.validate()) return;
              Navigator.of(context).pop((
                int.parse(_systolic.text.trim()),
                int.parse(_diastolic.text.trim()),
              ));
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save my reading', style: TextStyle(fontSize: 18)),
          )),
        ],
      ),
    )),
  );
}
