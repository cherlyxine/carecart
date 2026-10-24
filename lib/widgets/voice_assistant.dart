import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/care_models.dart';

/// A simple English command assistant. It uses locally available CareCart
/// records; it is not a medical adviser or a general AI chatbot.
class VoiceAssistantButton extends StatefulWidget {
  const VoiceAssistantButton({
    super.key,
    required this.medicines,
    required this.appointments,
    required this.onNavigate,
    required this.onSpeak,
  });

  final List<Medicine> medicines;
  final List<Appointment> appointments;
  final ValueChanged<String> onNavigate;
  final Future<void> Function(String) onSpeak;

  @override
  State<VoiceAssistantButton> createState() => _VoiceAssistantButtonState();
}

class _VoiceAssistantButtonState extends State<VoiceAssistantButton> {
  Future<void> _openAssistant() async {
    // Waiting for Navigator.pop avoids opening the next form underneath
    // an assistant route that is still on screen.
    final destination = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => _VoiceAssistantPage(
          medicines: widget.medicines,
          appointments: widget.appointments,
          onSpeak: widget.onSpeak,
        ),
      ),
    );
    if (!mounted || destination == null) return;
    widget.onNavigate(destination);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      heroTag: 'carecart_voice_assistant',
      tooltip: 'Open CareCart assistant',
      onPressed: _openAssistant,
      child: const Icon(Icons.support_agent, size: 38),
    );
  }
}

class _VoiceAssistantPage extends StatefulWidget {
  const _VoiceAssistantPage({
    required this.medicines,
    required this.appointments,
    required this.onSpeak,
  });

  final List<Medicine> medicines;
  final List<Appointment> appointments;
  final Future<void> Function(String) onSpeak;

  @override
  State<_VoiceAssistantPage> createState() => _VoiceAssistantPageState();
}

class _VoiceAssistantPageState extends State<_VoiceAssistantPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController _typed = TextEditingController();
  bool _listening = false;
  bool _starting = false;
  String _transcript = '';
  String _response = 'Hello! Ask me about your saved medicines or appointments.';
  String? _warning;
  bool _handledFinal = false;

  static const _examples = <String>[
    'What medicines do I have?',
    'Do I have an appointment?',
    'Create a new appointment',
    'Add a new medicine',
    'Open my Care Basket',
    'Open My Health',
  ];

  @override
  void dispose() {
    _speech.cancel();
    _typed.dispose();
    super.dispose();
  }

  Future<void> _toggleMicrophone() async {
    if (_starting) return;
    if (_listening) {
      await _speech.stop();
      if (!mounted) return;
      setState(() => _listening = false);
      if (_transcript.trim().isNotEmpty && !_handledFinal) {
        _respond(_transcript);
      }
      return;
    }
    setState(() {
      _starting = true;
      _warning = null;
      _transcript = '';
      _handledFinal = false;
    });
    try {
      // initialize requests microphone permission on Android when possible.
      final available = await _speech.initialize(
        onStatus: (status) {
          if (!mounted) return;
          if (status == 'done' || status == 'notListening') {
            setState(() => _listening = false);
          }
        },
        onError: (error) {
          if (!mounted) return;
          setState(() {
            _listening = false;
            _warning = 'Speech recognition error: ${error.errorMsg}. Check microphone access, the emulator microphone input, and the Android speech recognition service.';
          });
        },
      );
      if (!mounted) return;
      if (!available) {
        setState(() {
          _warning = 'Microphone unavailable or permission not granted. Enable microphone permission in Android Settings > Apps > CareCart > Permissions.';
          _starting = false;
        });
        return;
      }
      // Some Android emulators do not provide en_US speech recognition.
      // Use the English locale if available, or the system default.
      String? englishLocale;
      try {
        final locales = await _speech.locales();
        for (final locale in locales) {
          if (locale.localeId.toLowerCase() == 'en_us') {
            englishLocale = locale.localeId;
            break;
          }
        }
        if (englishLocale == null) {
          for (final locale in locales) {
            if (locale.localeId.toLowerCase().startsWith('en')) {
              englishLocale = locale.localeId;
              break;
            }
          }
        }
      } catch (_) {
        // The device may not support querying installed speech locales.
      }
      if (!mounted) return;
      setState(() { _starting = false; _listening = true; });
      await _speech.listen(
        listenOptions: stt.SpeechListenOptions(
          localeId: englishLocale,
          partialResults: true,
          listenFor: const Duration(seconds: 45),
          pauseFor: const Duration(seconds: 4),
        ),
        onResult: (result) {
          if (!mounted) return;
          setState(() => _transcript = result.recognizedWords);
          if (result.finalResult && !_handledFinal && _transcript.trim().isNotEmpty) {
            _handledFinal = true;
            _respond(_transcript);
          }
        },
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _starting = false;
        _listening = false;
        _warning = 'Microphone error: $error';
      });
    }
  }

  Future<void> _respond(String command) async {
    final q = command.toLowerCase().trim();
    if (q.isEmpty) return;
    await _speech.stop();
    if (!mounted) return;

    String answer;
    String? destination;
    final appointments = q.contains('appointment') || q.contains('doctor visit');
    final medicines = q.contains('medicine') || q.contains('medication') || q.contains('pill');
    final create = q.contains('add') || q.contains('new') || q.contains('create') ||
        q.contains('book') || q.contains('schedule');

    if (appointments && create) {
      answer = 'Opening the appointment form.';
      destination = 'addAppointment';
    } else if (medicines && create) {
      answer = 'Opening the medicine form.';
      destination = 'addMedicine';
    } else if (medicines) {
      answer = widget.medicines.isEmpty
          ? 'No medicines are saved in CareCart.'
          : 'Your saved medicines are: ${widget.medicines.map((m) => '${m.name}, ${m.dose}, ${m.time}').join('; ')}. Please check your prescription or care team instructions before taking medicine.';
    } else if (appointments) {
      answer = widget.appointments.isEmpty
          ? 'No appointments are saved in CareCart.'
          : 'Your saved appointments are: ${widget.appointments.map((a) => '${a.name}, ${a.date} at ${a.time}').join('; ')}. Open My Appointments to confirm the full date.';
    } else if (q.contains('basket') || q.contains('task') || q.contains('to do')) {
      answer = 'Opening your Care Basket.';
      destination = 'basket';
    } else if (q.contains('health') || q.contains('blood pressure')) {
      answer = 'Opening My Health.';
      destination = 'health';
    } else if (q.contains('help')) {
      answer = 'Opening Help.';
      destination = 'help';
    } else {
      answer = 'I can show your saved medicines and appointments, or open a page. Choose one of the example questions below.';
    }

    setState(() {
      _listening = false;
      _transcript = command;
      _response = answer;
      _warning = null;
    });
    if (destination != null) {
      // Return destination to floating button; navigate only after this page closes.
      Navigator.of(context).pop(destination);
      return;
    }
    try {
      await widget.onSpeak(answer);
    } catch (_) {
      // Written answer is always available.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareCart Assistant'),
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Semantics(
                button: true,
                label: _listening ? 'Stop listening' : 'Start voice recognition',
                child: SizedBox(
                  width: 136,
                  height: 136,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: _starting ? null : _toggleMicrophone,
                    child: Icon(_listening ? Icons.stop : Icons.mic, size: 64),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _starting
                    ? 'Starting microphone...'
                    : _listening
                        ? 'Listening... tap to stop'
                        : 'Tap to speak',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Show recognized words immediately below the microphone.
            Semantics(
              liveRegion: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  _transcript.isEmpty
                      ? (_listening
                          ? 'I am listening...'
                          : 'Your words will appear here as you speak.')
                      : _transcript,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 21,
                    height: 1.4,
                    color: _transcript.isEmpty
                        ? scheme.onSurfaceVariant
                        : scheme.onSurface,
                    fontWeight: _transcript.isEmpty
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Speak in English, or choose one of the questions below.',
              textAlign: TextAlign.center,
            ),
            if (_warning != null) ...[
              const SizedBox(height: 12),
              Text(
                _warning!,
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.error),
              ),
            ],
            const SizedBox(height: 28),
            Text('Questions you can ask', style: theme.textTheme.titleLarge),
            const SizedBox(height: 10),
            ..._examples.map((question) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(58),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onPressed: () => _respond(question),
                child: Text(question, style: const TextStyle(fontSize: 17)),
              ),
            )),
            const SizedBox(height: 18),
            Text('CareCart says', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_response, style: const TextStyle(fontSize: 17)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Prefer typing?',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            const Text('Write your question below, then tap Ask CareCart.'),
            const SizedBox(height: 12),
            TextField(
              controller: _typed,
              minLines: 3,
              maxLines: 5,
              style: const TextStyle(fontSize: 20, height: 1.4),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onSubmitted: _respond,
              decoration: InputDecoration(
                hintText: 'For example: Do I have an appointment?',
                hintMaxLines: 2,
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: () => _respond(_typed.text),
                icon: const Icon(Icons.send),
                label: const Text('Ask CareCart'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
