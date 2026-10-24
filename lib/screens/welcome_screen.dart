import 'package:flutter/material.dart';

class CareCartSetupMedicine {
  const CareCartSetupMedicine(this.name, this.dose, this.time);
  final String name;
  final String dose;
  final String time;
}

class CareCartSetupInfo {
  const CareCartSetupInfo({
    required this.name,
    required this.doctor,
    required this.medicines,
  });
  final String name;
  final String doctor;
  final List<CareCartSetupMedicine> medicines;
}

/// A one-time, screen-by-screen onboarding wizard.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.onComplete});
  final Future<void> Function(CareCartSetupInfo) onComplete;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const _green = Color(0xFF315747);
  static const _cream = Color(0xFFFAF7F0);
  static const _ink = Color(0xFF243D33);
  final _name = TextEditingController();
  final _doctor = TextEditingController();
  final List<CareCartSetupMedicine> _medicines = [];
  int _step = 0;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _doctor.dispose();
    super.dispose();
  }

  void _next() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_step == 1 && _name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name to continue.')),
      );
      return;
    }
    if (_step < 4) setState(() => _step++);
  }

  Future<void> _finish() async {
    if (_saving) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _saving = true);
    try {
      await widget.onComplete(CareCartSetupInfo(
        name: _name.text.trim(),
        doctor: _doctor.text.trim(),
        medicines: List.of(_medicines),
      ));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save your details. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _addMedicine() async {
    // The sheet owns its text controllers until its exit animation finishes.
    // Disposing them immediately after Navigator.pop can crash Flutter.
    final added = await showModalBottomSheet<CareCartSetupMedicine>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cream,
      useSafeArea: true,
      builder: (_) => const _CareCartMedicineEntrySheet(),
    );

    if (!mounted || added == null) return;
    setState(() => _medicines.add(added));
  }

  static InputDecoration _field(String label, String hint) => InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
  );

  Widget _hero(IconData symbol) => Container(
    width: 78, height: 78,
    decoration: BoxDecoration(color: const Color(0xFFE0EEE6),
        borderRadius: BorderRadius.circular(24)),
    child: Icon(symbol, color: _green, size: 37),
  );

  Widget _stepContent() {
    switch (_step) {
      case 0:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Image.asset('assets/icon/carecart_icon.png',
              width: 110, height: 110, fit: BoxFit.contain)),
          const SizedBox(height: 32),
          const Text('Care made simple.', style: TextStyle(fontSize: 36,
              height: 1.1, fontWeight: FontWeight.bold, color: _ink)),
          const SizedBox(height: 14),
          const Text('Welcome to CareCart. Let’s make this app yours, one step at a time.',
              style: TextStyle(fontSize: 19, height: 1.5)),
          const SizedBox(height: 26),
          const _SimpleInfo(icon: Icons.touch_app_outlined,
              text: 'Easy to use, with clear and large buttons.'),
          const SizedBox(height: 12),
          const _SimpleInfo(icon: Icons.lock_outline,
              text: 'Your details are saved on this device.'),
        ]);
      case 1:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _hero(Icons.person_outline),
          const SizedBox(height: 26),
          const Text('What should we call you?',
              style: TextStyle(fontSize: 32, height: 1.15,
                  fontWeight: FontWeight.bold, color: _ink)),
          const SizedBox(height: 12),
          const Text('We will use your name to welcome you.',
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 28),
          TextField(controller: _name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 20),
              decoration: _field('Your name', 'e.g. Anna')),
        ]);
      case 2:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _hero(Icons.medical_services_outlined),
          const SizedBox(height: 26),
          const Text('Who is your doctor?',
              style: TextStyle(fontSize: 32, height: 1.15,
                  fontWeight: FontWeight.bold, color: _ink)),
          const SizedBox(height: 12),
          const Text('You can add your doctor’s name now or skip this step.',
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 28),
          TextField(controller: _doctor,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 20),
              decoration: _field('Doctor’s name (optional)', 'e.g. Dr. Taylor')),
        ]);
      case 3:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _hero(Icons.medication_outlined),
          const SizedBox(height: 26),
          const Text('Do you take any medicines?',
              style: TextStyle(fontSize: 31, height: 1.18,
                  fontWeight: FontWeight.bold, color: _ink)),
          const SizedBox(height: 10),
          const Text('Add them one by one. You can also do this later.',
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          for (var i = 0; i < _medicines.length; i++)
            Card(color: Colors.white, child: ListTile(
              leading: const Icon(Icons.medication_outlined, color: _green),
              title: Text(_medicines[i].name, style: const TextStyle(fontSize: 18)),
              subtitle: Text('${_medicines[i].dose} · ${_medicines[i].time}'),
              trailing: IconButton(
                tooltip: 'Remove medicine', icon: const Icon(Icons.close),
                onPressed: () => setState(() => _medicines.removeAt(i)),
              ),
            )),
          const SizedBox(height: 12),
          SizedBox(height: 62, width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: _green,
                side: const BorderSide(color: _green),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
              ),
              onPressed: _addMedicine,
              icon: const Icon(Icons.add_circle_outline, size: 25),
              label: const Text('Add a medicine', style: TextStyle(fontSize: 19)),
            ),
          ),
        ]);
      default:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _hero(Icons.check_circle_outline),
          const SizedBox(height: 28),
          Text('You’re all set, ${_name.text.trim().split(' ').first}!',
              style: const TextStyle(fontSize: 32, height: 1.15,
                  fontWeight: FontWeight.bold, color: _ink)),
          const SizedBox(height: 14),
          const Text('Your CareCart is ready.', style: TextStyle(fontSize: 19)),
          const SizedBox(height: 26),
          _reviewRow(Icons.person_outline, 'Name', _name.text.trim()),
          _reviewRow(Icons.medical_services_outlined, 'Doctor',
              _doctor.text.trim().isEmpty ? 'Not added' : _doctor.text.trim()),
          _reviewRow(Icons.medication_outlined, 'Medicines added',
              '${_medicines.length}'),
          const SizedBox(height: 20),
          const Text('You can update your information later in the app.',
              style: TextStyle(fontSize: 16)),
        ]);
    }
  }

  Widget _reviewRow(IconData icon, String label, String value) =>
      Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(16)),
        child: Row(children: [Icon(icon, color: _green), const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(label, style: const TextStyle(color: Colors.black54)),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))]))]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(24, 15, 24, 12),
          child: Row(children: [
            if (_step > 0)
              IconButton(onPressed: _saving ? null : () => setState(() => _step--),
                  tooltip: 'Previous step', icon: const Icon(Icons.arrow_back_ios_new))
            else const SizedBox(width: 48),
            const Expanded(child: Text('CareCart', textAlign: TextAlign.center,
              style: TextStyle(color: _ink, fontWeight: FontWeight.bold, fontSize: 18))),
            Text('${_step + 1} / 5', style: const TextStyle(fontSize: 16, color: _green)),
          ]),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 26),
          child: ClipRRect(borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: (_step + 1) / 5,
              minHeight: 6, color: _green,
              backgroundColor: const Color(0xFFDCE7DD))),
        ),
        Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 230),
          child: SingleChildScrollView(
            key: ValueKey(_step),
            padding: const EdgeInsets.fromLTRB(26, 32, 26, 22),
            child: _stepContent(),
          ),
        )),
        Container(padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          color: _cream,
          child: Column(children: [
            SizedBox(width: double.infinity, height: 62,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: _green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                onPressed: _saving ? null : (_step == 4 ? _finish : _next),
                child: _saving ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_step == 4 ? 'Start using CareCart' : _step == 0 ? 'Get started' : 'Continue',
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
              ),
            ),
            if (_step == 2 || _step == 3)
              TextButton(onPressed: _saving ? null : _next,
                child: const Text('Skip for now', style: TextStyle(color: _green, fontSize: 17))),
          ]),
        ),
      ])),
    );
  }
}

class _SimpleInfo extends StatelessWidget {
  const _SimpleInfo({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, color: const Color(0xFF315747), size: 28),
    const SizedBox(width: 15),
    Expanded(child: Text(text, style: const TextStyle(fontSize: 17, height: 1.4))),
  ]);
}

/// Separate state keeps form controllers alive for the complete sheet lifecycle.
class _CareCartMedicineEntrySheet extends StatefulWidget {
  const _CareCartMedicineEntrySheet();

  @override
  State<_CareCartMedicineEntrySheet> createState() =>
      _CareCartMedicineEntrySheetState();
}

class _CareCartMedicineEntrySheetState
    extends State<_CareCartMedicineEntrySheet> {
  final _medicineName = TextEditingController();
  final _dose = TextEditingController();
  final _time = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _medicineName.dispose();
    _dose.dispose();
    _time.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(
      CareCartSetupMedicine(
        _medicineName.text.trim(),
        _dose.text.trim().isEmpty ? 'Dose not entered' : _dose.text.trim(),
        _time.text.trim().isEmpty ? 'Time not entered' : _time.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        22, 22, 22, MediaQuery.viewInsetsOf(context).bottom + 26,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add a medicine', style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF243D33),
              )),
              const SizedBox(height: 8),
              const Text('Copy the details from your prescription or medicine label.'),
              const SizedBox(height: 18),
              TextFormField(
                controller: _medicineName,
                textCapitalization: TextCapitalization.words,
                decoration: _WelcomeScreenState._field('Medicine name', 'e.g. Vitamin D'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Medicine name is required' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _dose,
                decoration: _WelcomeScreenState._field('Dose (optional)', 'e.g. 5 mg'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _time,
                decoration: _WelcomeScreenState._field('When do you take it? (optional)', 'e.g. In the morning'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF315747),
                  ),
                  onPressed: _save,
                  child: const Text('Save medicine', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
