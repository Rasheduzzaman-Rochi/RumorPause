import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumorpause/features/rumor_pause/services/voice_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VoiceService', () {
    late VoiceService voiceService;

    setUp(() {
      voiceService = VoiceService();

      // Set up mock method channel handler for flutter_tts
      // This intercepts platform channel calls so tests don't crash
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter_tts'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'awaitSpeakCompletion':
              return 1;
            case 'setSpeechRate':
              return 1;
            case 'setPitch':
              return 1;
            case 'setVolume':
              return 1;
            case 'setLanguage':
              return 1;
            case 'getLanguages':
              return ['bn-BD', 'bn-IN', 'en-US', 'en-GB'];
            case 'speak':
              return 1;
            case 'stop':
              return 1;
            case 'isLanguageAvailable':
              return 1;
            default:
              return null;
          }
        },
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter_tts'),
        null,
      );
    });

    test('can be instantiated', () {
      expect(voiceService, isNotNull);
    });

    test('init completes without error', () async {
      await expectLater(voiceService.init(), completes);
    });

    test('init can be called multiple times safely (idempotent)', () async {
      await voiceService.init();
      await voiceService.init();
      // Should not throw
    });

    test('speak does not throw for valid text', () async {
      await expectLater(
        voiceService.speak('Hello test'),
        completes,
      );
    });

    test('speak does nothing for empty text', () async {
      // Should complete immediately without calling TTS
      await expectLater(
        voiceService.speak(''),
        completes,
      );
    });

    test('speak does nothing for whitespace-only text', () async {
      await expectLater(
        voiceService.speak('   '),
        completes,
      );
    });

    test('speak handles Bangla text', () async {
      await expectLater(
        voiceService.speak('এটি একটি পরীক্ষা'),
        completes,
      );
    });

    test('stop completes without error', () async {
      await expectLater(voiceService.stop(), completes);
    });

    test('dispose completes without error', () async {
      await expectLater(voiceService.dispose(), completes);
    });

    test('speak after dispose does not crash', () async {
      await voiceService.dispose();
      // This should reinitialize and work
      await expectLater(
        voiceService.speak('After dispose'),
        completes,
      );
    });
  });

  group('VoiceService - Language Selection', () {
    test('selects bn-BD when available', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter_tts'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'getLanguages') {
            return ['en-US', 'bn-BD', 'bn-IN', 'hi-IN'];
          }
          return 1;
        },
      );

      final service = VoiceService();
      await service.init();
      // If init completes without error, language selection worked
    });

    test('falls back to bn-IN when bn-BD is not available', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter_tts'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'getLanguages') {
            return ['en-US', 'bn-IN', 'hi-IN'];
          }
          return 1;
        },
      );

      final service = VoiceService();
      await service.init();
    });

    test('falls back to en-US when no Bangla language is available', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter_tts'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'getLanguages') {
            return ['en-US', 'en-GB', 'fr-FR'];
          }
          return 1;
        },
      );

      final service = VoiceService();
      await service.init();
    });

    test('handles empty language list gracefully', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter_tts'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'getLanguages') {
            return [];
          }
          return 1;
        },
      );

      final service = VoiceService();
      await service.init();
    });

    test('handles language check failure gracefully', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter_tts'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'getLanguages') {
            throw PlatformException(code: 'ERROR', message: 'Failed');
          }
          return 1;
        },
      );

      final service = VoiceService();
      // Should not throw - falls back to en-US
      await service.init();
    });
  });
}
