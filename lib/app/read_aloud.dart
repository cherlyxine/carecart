part of 'carecart_root.dart';

extension _ReadAloud on _CareCartRootState {
  // Human-written screen summaries; no private medical data is sent to a server.
  String _pageSpeech() {
    switch (page) {
      case 'accessibility':
        return 'Accessibility. Make CareCart easier. Choose what makes CareCart '
            'more comfortable for you. Larger text. Read aloud. Higher contrast. '
            'Slow down animations. Stronger notifications.';
      case 'health':
        return 'My health. Recent measurements. Blood pressure. '
            '${measured ? '$systolic over $diastolic' : 'Sample reading, 128 over 78'}. '
            'Things to discuss with my doctor. '
            '${notes.isEmpty ? 'No notes yet.' : notes.join('. ')}. Add a note.';
      case 'medicines':
        return 'My medicines. Add a medicine. '
            '${medicines.isEmpty ? 'No medicines saved.' : medicines.map((m) => '${m.name}, ${m.dose}, ${m.time}').join('. ')}.';
      case 'appointments':
        return 'My appointments. Add an appointment. '
            '${appointments.isEmpty ? 'No appointments saved.' : appointments.map((a) => '${a.name}, ${a.date}, ${a.time}').join('. ')}.';
      case 'profile':
        return 'My profile. My details. Accessibility and settings.';
      case 'guidance':
        return 'Daily guidance. Check your blood pressure. Take your time. '
            'Follow the instructions on screen.';
      case 'reading':
        return 'Blood pressure reading. Follow the steps shown on screen.';
      case 'finished':
        return 'Well done. You have finished this step.';
      default:
        switch (tab) {
          case 0:
            return 'Today. Good morning, ${name.split(' ').first}. '
                'You have one thing to do today. Check your blood pressure. '
                'Take your time. We will guide you. About five minutes.';
          case 1:
            return 'My care basket. Your daily care tasks. '
                '${tasks.asMap().entries.map((e) => '${e.value}, ${completed.contains(e.key) ? 'completed' : 'not completed'}').join('. ')}.';
          case 2:
            return 'Care aisles. My health. My medicines. My appointments.';
          default:
            return 'Help. Choose an option if you need assistance.';
        }
    }
  }

  Future<void> _stopSpeech() async {
    _speechRequest++;
    if (_isSpeaking && mounted) _update(() => _isSpeaking = false);
    try {
      await _tts.stop();
    } catch (_) {
      // A missing device voice engine should not crash CareCart.
    }
  }

  Future<void> _toggleSpeech() async {
    if (_isSpeaking) {
      await _stopSpeech();
      return;
    }
    final request = ++_speechRequest;
    try {
      await _tts.stop();
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.43);
      await _tts.setVolume(1.0);
      if (!mounted || request != _speechRequest) return;
      _update(() => _isSpeaking = true);
      await _tts.speak(_pageSpeech());
    } catch (_) {
      if (!mounted || request != _speechRequest) return;
      _update(() => _isSpeaking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech is unavailable. Check your device text-to-speech settings.')),
      );
    }
  }
}
