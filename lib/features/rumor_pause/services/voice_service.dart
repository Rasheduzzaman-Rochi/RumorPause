import 'dart:developer';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  VoiceService();

  final FlutterTts _flutterTts = FlutterTts();

  bool _isInitialized = false;
  String _selectedLanguage = 'bn-BD';

  Future<void> init() async {
    if (_isInitialized) return;

    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setSpeechRate(0.38);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);

    await _setBestBanglaLanguage();

    _flutterTts.setStartHandler(() {
      log('TTS started');
    });

    _flutterTts.setCompletionHandler(() {
      log('TTS completed');
    });

    _flutterTts.setErrorHandler((message) {
      log('TTS error: $message');
    });

    _isInitialized = true;
  }

  Future<void> _setBestBanglaLanguage() async {
    try {
      final languages = await _flutterTts.getLanguages;
      log('Available TTS languages: $languages');

      final List<String> preferredLanguages = [
        'bn-BD',
        'bn-IN',
        'bn',
        'en-US',
      ];

      String selected = 'en-US';

      if (languages is List) {
        for (final language in preferredLanguages) {
          if (languages.contains(language)) {
            selected = language;
            break;
          }
        }
      }

      _selectedLanguage = selected;
      await _flutterTts.setLanguage(_selectedLanguage);

      log('Selected TTS language: $_selectedLanguage');
    } catch (e) {
      log('Language check failed: $e');
      _selectedLanguage = 'en-US';
      await _flutterTts.setLanguage(_selectedLanguage);
    }
  }

  Future<void> speak(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    await init();

    await stop();
    await Future.delayed(const Duration(milliseconds: 250));

    log('Speaking with language $_selectedLanguage: $cleanText');
    await _flutterTts.speak(cleanText);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Future<void> dispose() async {
    await stop();
  }
}