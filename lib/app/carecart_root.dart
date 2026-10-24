import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../widgets/voice_assistant.dart';
import 'dart:io';
import '../models/care_models.dart';
import '../theme/app_colors.dart';
import '../screens/welcome_screen.dart';
import '../screens/add_medicine_screen.dart';
import '../screens/add_appointment_screen.dart';
import '../screens/blood_pressure_entry_screen.dart';

part '../widgets/common_widgets.dart';
part '../screens/today_screen.dart';
part '../screens/guidance_screen.dart';
part '../screens/reading_screen.dart';
part '../screens/finished_screen.dart';
part '../screens/basket_screen.dart';
part '../screens/aisles_screen.dart';
part '../screens/health_screen.dart';
part '../screens/medicines_screen.dart';
part '../screens/appointments_screen.dart';
part '../screens/help_screen.dart';
part '../screens/profile_screen.dart';
part '../screens/accessibility_screen.dart';
part 'dialogs.dart';
part 'read_aloud.dart';
part 'care_storage.dart';

class CareCartRoot extends StatefulWidget {
  const CareCartRoot({super.key});
  @override
  State<CareCartRoot> createState() => _CareCartRootState();
}

class _CareCartRootState extends State<CareCartRoot> {
  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;
  int _speechRequest = 0;

  @override
  void initState() {
    super.initState();
    _restoreCareData();
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _tts.setErrorHandler((_) {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _saveCareData();
    _tts.stop();
    super.dispose();
  }

  bool started = false;
  bool _bootReady = false;
  String preferredDoctor = '';

  Future<void> _completeFirstSetup(CareCartSetupInfo info) async {
    setState(() {
      name = info.name.trim();
      preferredDoctor = info.doctor.trim();
      for (final item in info.medicines) {
        // Avoid adding duplicate medicine names to the demo list.
        if (!medicines.any((m) => m.name.toLowerCase() == item.name.toLowerCase())) {
          medicines.add(Medicine(item.name, item.dose, item.time, 'Follow your care team instructions.'));
        }
      }
      started = true;
      tab = 0;
      page = '';
    });
    await _saveCareData();
  }

  int tab = 0;
  String page = '';
  final List<Medicine> medicines = [
    Medicine('Amlodipine', '5 mg · 1 tablet', '8:00 in the morning', 'Follow your care team instructions'),
    Medicine('Vitamin D', '10 micrograms · 1 tablet', '8:00 in the morning', 'Take with breakfast'),
    Medicine('Atorvastatin', '1 tablet', 'Evening', 'Follow your care team instructions'),
  ];
  final List<Appointment> appointments = [
    Appointment('GP appointment', '15 May', '10:30', 'Rosewood Medical Centre', 'Dr. Helen Morris'),
  ];
  final List<String> tasks = ['Check blood pressure', 'Take morning medicine', 'Prepare for GP appointment', 'Drink enough water'];
  final Set<int> completed = {};
  final List<String> notes = ['Mention that I sometimes feel tired in the afternoon.'];
  final Map<String, bool> accessibility = {
    'Larger text': false,
    'Read aloud': true,
    'Higher contrast': false,
    'Slow down animations': false,
    'Stronger notifications': false,
  };
  double textScale = 1.0;
  String name = 'Anna Wilson';
  bool measured = false;
  String systolic = '', diastolic = '';

  bool _dataRestored = false;
  Timer? _saveDebounce;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (_dataRestored) _scheduleCareSave();
  }

  void open(String target) {
    _stopSpeech();
    setState(() => page = target);
  }
  void goTab(int value) {
    _stopSpeech();
    setState(() { tab = value; page = ''; });
  }
  void back() {
    _stopSpeech();
    setState(() => page = '');
  }

  Future<void> _speakAssistantReply(String message) async {
    await _stopSpeech();
    if (!mounted) return;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.43);
      await _tts.speak(message);
    } catch (_) {
      // The written response is still visible when TTS is unavailable.
    }
  }

  void _assistantNavigate(String destination) {
    if (destination == 'addAppointment') {
      open('appointments');
      _addAppointment();
    } else if (destination == 'addMedicine') {
      open('medicines');
      _addMedicine();
    } else if (destination == 'basket') {
      goTab(1);
    } else if (destination == 'help') {
      goTab(3);
    } else {
      open(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = textScale;
    final contrast = accessibility['Higher contrast'] == true;
    final baseline = Theme.of(context);
    final chosenTheme = contrast ? baseline.copyWith(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(primary: Colors.black, onPrimary: Colors.white, surface: Colors.white, onSurface: Colors.black),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white)),
      cardTheme: CardThemeData(color: Colors.white, shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(12))),
    ) : baseline;
    return Theme(data: chosenTheme, child: Stack(
      children: [
        MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
      child: !_bootReady
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : !started
          ? WelcomeScreen(onComplete: _completeFirstSetup)
          : Scaffold(
              appBar: AppBar(
                backgroundColor: contrast ? Colors.white : cream,
                foregroundColor: contrast ? Colors.black : null,
                leading: page.isNotEmpty ? IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: back) : null,
                title: page.isEmpty ? Row(mainAxisSize: MainAxisSize.min, children: [Image.asset('assets/icon/carecart_icon.png', width: 25, height: 25), const SizedBox(width: 8), const Text('CareCart', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))]) : const SizedBox.shrink(),
                actions: [
                  if (accessibility['Read aloud'] == true)
                    IconButton(
                      tooltip: _isSpeaking ? 'Stop reading' : 'Read this page aloud',
                      iconSize: 32,
                      icon: Icon(_isSpeaking ? Icons.stop_circle_outlined : Icons.volume_up_outlined),
                      onPressed: _toggleSpeech,
                    ),
                  TextButton.icon(onPressed: () => open('accessibility'), icon: const Icon(Icons.auto_awesome, size: 15), label: const Text('Accessibility')),
                  IconButton(onPressed: () => open('profile'), icon: const Icon(Icons.person_outline)),
                ],
              ),
              backgroundColor: contrast ? Colors.white : cream,
              body: SafeArea(child: _body()),
              bottomNavigationBar: NavigationBar(
                height: 70,
                selectedIndex: tab,
                onDestinationSelected: goTab,
                destinations: [
                  const NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Today'),
                  NavigationDestination(icon: Image.asset('assets/icon/carecart_icon.png', width: 25, height: 25), selectedIcon: Image.asset('assets/icon/carecart_icon.png', width: 25, height: 25), label: 'Basket'),
                  const NavigationDestination(icon: Icon(Icons.table_restaurant_outlined), label: 'Aisles'),
                  const NavigationDestination(icon: Icon(Icons.headset_mic_outlined), label: 'Help'),
                ],
              ),
            ),
        ),
        if (started && _bootReady) Positioned(
          right: 16,
          bottom: started ? 88 : 18,
          child: Material(
            type: MaterialType.transparency,
            child: VoiceAssistantButton(
              medicines: medicines,
              appointments: appointments,
              onNavigate: _assistantNavigate,
              onSpeak: _speakAssistantReply,
            ),
          ),
        ),
      ],
    ));
  }

  void _update(VoidCallback change) => setState(change);

  Widget _body() {
    switch (page) {
      case 'profile': return _profile();
      case 'accessibility': return _accessibility();
      case 'health': return _health();
      case 'medicines': return _medicines();
      case 'appointments': return _appointments();
      case 'reading': return _reading();
      case 'finished': return _finished();
      case 'guidance': return _guidance();
      default:
        return [ _today(), _basket(), _aisles(), _help() ][tab];
    }
  }

}
