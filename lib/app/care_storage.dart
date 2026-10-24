part of 'carecart_root.dart';

/// Stores ordinary CareCart demo records on this device.
/// It is NOT encrypted clinical storage and is not intended for sensitive records.
extension _CareStorage on _CareCartRootState {
  static const _storageKey = 'carecart_data_v1';

  Future<void> _restoreCareData() async {
    try {
      final prefs = SharedPreferencesAsync();
      final raw = await prefs.getString(_storageKey);
      if (!mounted) return;
      if (raw != null) {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        setState(() {
          if (data['medicines'] is List) {
            medicines
              ..clear()
              ..addAll((data['medicines'] as List).map((entry) {
                final m = Map<String, dynamic>.from(entry as Map);
                return Medicine(
                  (m['name'] ?? '').toString(),
                  (m['dose'] ?? '').toString(),
                  (m['time'] ?? '').toString(),
                  (m['instructions'] ?? '').toString(),
                  taken: m['taken'] == true,
                  photoPath: m['photoPath']?.toString(),
                );
              }));
          }
          if (data['appointments'] is List) {
            appointments
              ..clear()
              ..addAll((data['appointments'] as List).map((entry) {
                final a = Map<String, dynamic>.from(entry as Map);
                return Appointment(
                  (a['name'] ?? '').toString(),
                  (a['date'] ?? '').toString(),
                  (a['time'] ?? '').toString(),
                  (a['place'] ?? '').toString(),
                  (a['doctor'] ?? '').toString(),
                  attended: a['attended'] == true,
                );
              }));
          }
          if (data['tasks'] is List) {
            tasks..clear()..addAll((data['tasks'] as List).map((e) => e.toString()));
          }
          if (data['completed'] is List) {
            completed..clear()..addAll((data['completed'] as List).whereType<num>().map((e) => e.toInt()).where((i) => i >= 0 && i < tasks.length));
          }
          if (data['notes'] is List) {
            notes..clear()..addAll((data['notes'] as List).map((e) => e.toString()));
          }
          if (data['accessibility'] is Map) {
            final values = Map<String, dynamic>.from(data['accessibility'] as Map);
            for (final key in accessibility.keys) {
              if (values[key] is bool) accessibility[key] = values[key] as bool;
            }
          }
          name = (data['name'] ?? name).toString();
          preferredDoctor = (data['preferredDoctor'] ?? '').toString();
          started = data['setupComplete'] == true;
          measured = data['measured'] == true;
          systolic = (data['systolic'] ?? '').toString();
          diastolic = (data['diastolic'] ?? '').toString();
          final savedScale = data['textScale'];
          if (savedScale is num) textScale = savedScale.toDouble().clamp(1.0, 2.0);
        });
      }
    } catch (e) {
      debugPrint('CareCart: could not restore locally saved data: $e');
    } finally {
      if (mounted) {
        // Do not persist onboarding status until saved data has been loaded.
        setState(() => _bootReady = true);
        _dataRestored = true;
        _scheduleCareSave();
      }
    }
  }

  void _scheduleCareSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 200), _saveCareData);
  }

  Future<void> _saveCareData() async {
    if (!_dataRestored) return;
    final data = <String, dynamic>{
      'medicines': [for (final m in medicines) {
        'name': m.name, 'dose': m.dose, 'time': m.time,
        'instructions': m.instructions, 'taken': m.taken,
        'photoPath': m.photoPath,
      }],
      'appointments': [for (final a in appointments) {
        'name': a.name, 'date': a.date, 'time': a.time,
        'place': a.place, 'doctor': a.doctor, 'attended': a.attended,
      }],
      'tasks': tasks,
      'completed': completed.toList(),
      'notes': notes,
      'accessibility': accessibility,
      'name': name,
      'preferredDoctor': preferredDoctor,
      'setupComplete': started,
      'measured': measured,
      'systolic': systolic,
      'diastolic': diastolic,
      'textScale': textScale,
    };
    try {
      await SharedPreferencesAsync().setString(_storageKey, jsonEncode(data));
    } catch (e) {
      debugPrint('CareCart: could not save local data: $e');
    }
  }
}
