import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/care_models.dart';
import '../theme/app_colors.dart';

/// Collects details for one medicine and returns it to the calling screen.
/// It does not modify the medicines list directly.
class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _dose = TextEditingController();
  final _time = TextEditingController();
  final _instructions = TextEditingController();
  final _picker = ImagePicker();
  String? _selectedPath;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _dose.dispose();
    _time.dispose();
    _instructions.dispose();
    super.dispose();
  }

  Future<void> _choosePhoto() async {
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 1400,
      );
      if (!mounted || photo == null) return;
      setState(() => _selectedPath = photo.path);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open photos. Please try again.')),
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    String? savedPhoto;
    try {
      if (_selectedPath != null) {
        // Picker paths may be temporary. Keep our own app-local copy.
        final folder = await getApplicationDocumentsDirectory();
        final destination = Directory('${folder.path}/medicine_photos');
        await destination.create(recursive: true);
        final original = _selectedPath!.toLowerCase();
        final extension = original.endsWith('.png') ? '.png' : '.jpg';
        final path = '${destination.path}/medicine_${DateTime.now().microsecondsSinceEpoch}$extension';
        await File(_selectedPath!).copy(path);
        savedPhoto = path;
      }
      if (!mounted) return;
      Navigator.of(context).pop(Medicine(
        _name.text.trim(), _dose.text.trim(), _time.text.trim(),
        _instructions.text.trim(), photoPath: savedPhoto,
      ));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the photo. Please try again.')),
      );
      setState(() => _saving = false);
    }
  }

  Widget _field(String label, TextEditingController controller,
      {String? hint, int lines = 1, bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: lines,
        textCapitalization: TextCapitalization.sentences,
        validator: required
            ? (text) => text == null || text.trim().isEmpty
                ? 'Please enter the medicine name'
                : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: lines > 1,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(backgroundColor: cream, title: const Text('Add a medicine')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            children: [
              _field('Medicine name', _name, required: true),
              _field('Dose', _dose, hint: 'For example: 5 mg · 1 tablet'),
              _field('When to take it', _time,
                  hint: 'For example: 8:00 in the morning'),
              _field('Instructions', _instructions,
                  hint: 'For example: Take with breakfast', lines: 3),
              const SizedBox(height: 4),
              const Text('Medicine photo',
                  style: TextStyle(fontWeight: FontWeight.w600, color: ink)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _saving ? null : _choosePhoto,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: mint),
                  ),
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 54, width: 54,
                        child: _selectedPath == null
                            ? const ColoredBox(
                                color: mint,
                                child: Icon(Icons.medication_outlined, color: forest),
                              )
                            : Image.file(File(_selectedPath!), fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const Icon(Icons.broken_image_outlined)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_selectedPath == null ? 'Choose a photo' : 'Change photo',
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        const Text('JPG or PNG · optional',
                            style: TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    )),
                    const Icon(Icons.chevron_right, color: forest),
                  ]),
                ),
              ),
              if (_selectedPath != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _selectedPath = null),
                    icon: const Icon(Icons.close),
                    label: const Text('Remove photo'),
                  ),
                ),
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Saving...' : 'Save medicine'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: _saving ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
