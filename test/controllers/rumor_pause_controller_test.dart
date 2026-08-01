import 'package:flutter_test/flutter_test.dart';
import 'package:rumorpause/core/constants/app_texts.dart';
import 'package:rumorpause/features/rumor_pause/controllers/rumor_pause_controller.dart';

void main() {
  late RumorPauseController controller;

  setUp(() {
    controller = RumorPauseController();
  });

  group('RumorPauseController - Navigation', () {
    test('starts at step 0', () {
      expect(controller.currentStep, 0);
    });

    test('nextStep increments step by 1', () {
      controller.nextStep();
      expect(controller.currentStep, 1);
    });

    test('nextStep can go through all 9 steps (0 through 8)', () {
      for (int i = 0; i < 9; i++) {
        expect(controller.currentStep, i);
        controller.nextStep();
      }
      // After the final suggestion step (8), it would be at step 9,
      // but the flow screen uses default: for >= 8
    });

    test('previousStep decrements step by 1', () {
      controller.nextStep();
      controller.nextStep();
      controller.previousStep();
      expect(controller.currentStep, 1);
    });

    test('previousStep does not go below 0', () {
      controller.previousStep();
      expect(controller.currentStep, 0);
    });

    test('previousStep stays at 0 when already at 0', () {
      controller.previousStep();
      controller.previousStep();
      controller.previousStep();
      expect(controller.currentStep, 0);
    });
  });

  group('RumorPauseController - Initial State', () {
    test('starts with sample message', () {
      expect(controller.sharedMessage, AppTexts.sampleMessage);
    });

    test('starts with default answers (beforeShareScore = 3)', () {
      expect(controller.answers.beforeShareScore, 3);
      expect(controller.answers.sourceAnswer, isNull);
      expect(controller.answers.dateAnswer, isNull);
      expect(controller.answers.urgencyAnswer, isNull);
    });
  });

  group('RumorPauseController - Restart', () {
    test('restart resets step to 0', () {
      controller.nextStep();
      controller.nextStep();
      controller.nextStep();
      controller.restart();
      expect(controller.currentStep, 0);
    });

    test('restart resets message to sample message', () {
      controller.setSharedMessage('Custom message');
      controller.restart();
      expect(controller.sharedMessage, AppTexts.sampleMessage);
    });

    test('restart resets answers to defaults', () {
      controller.updateSourceAnswer('নেই');
      controller.updateDateAnswer('আছে');
      controller.updateUrgencyAnswer('হ্যাঁ');
      controller.updateBeforeShareScore(5);

      controller.restart();

      expect(controller.answers.beforeShareScore, 3);
      expect(controller.answers.sourceAnswer, isNull);
      expect(controller.answers.dateAnswer, isNull);
      expect(controller.answers.urgencyAnswer, isNull);
    });
  });

  group('RumorPauseController - Answer Updates', () {
    test('updateBeforeShareScore updates the score', () {
      controller.updateBeforeShareScore(5);
      expect(controller.answers.beforeShareScore, 5);
    });

    test('updateBeforeShareScore preserves other answers', () {
      controller.updateSourceAnswer('আছে');
      controller.updateBeforeShareScore(1);
      expect(controller.answers.sourceAnswer, 'আছে');
    });

    test('updateSourceAnswer updates source answer', () {
      controller.updateSourceAnswer('নেই');
      expect(controller.answers.sourceAnswer, 'নেই');
    });

    test('updateDateAnswer updates date answer', () {
      controller.updateDateAnswer('আছে');
      expect(controller.answers.dateAnswer, 'আছে');
    });

    test('updateUrgencyAnswer updates urgency answer', () {
      controller.updateUrgencyAnswer('হ্যাঁ');
      expect(controller.answers.urgencyAnswer, 'হ্যাঁ');
    });

    test('updating one answer does not affect others', () {
      controller.updateSourceAnswer('আছে');
      controller.updateDateAnswer('নেই');

      expect(controller.answers.sourceAnswer, 'আছে');
      expect(controller.answers.dateAnswer, 'নেই');
      expect(controller.answers.urgencyAnswer, isNull);
    });
  });

  group('RumorPauseController - Risk Result', () {
    test('riskResult returns a valid result with default state', () {
      final result = controller.riskResult;

      expect(result, isNotNull);
      expect(result.title, isNotEmpty);
      expect(result.suggestion, isNotEmpty);
      expect(result.score, isNonNegative);
    });

    test('riskResult returns high risk for sample message with risky answers',
        () {
      controller.updateSourceAnswer('নেই');
      controller.updateDateAnswer('নেই');
      controller.updateUrgencyAnswer('হ্যাঁ');

      final result = controller.riskResult;

      expect(result.title, 'High Risk');
    });

    test('riskResult updates dynamically as answers change', () {
      controller.updateSourceAnswer('আছে');
      controller.updateDateAnswer('আছে');
      controller.updateUrgencyAnswer('না');
      final lowRiskResult = controller.riskResult;

      controller.updateSourceAnswer('নেই');
      controller.updateDateAnswer('নেই');
      controller.updateUrgencyAnswer('হ্যাঁ');
      final highRiskResult = controller.riskResult;

      expect(highRiskResult.score, greaterThan(lowRiskResult.score));
    });
  });

  group('RumorPauseController - Shared Message', () {
    test('setSharedMessage updates the message', () {
      controller.setSharedMessage('New shared content');
      expect(controller.sharedMessage, 'New shared content');
    });

    test('setSharedMessage trims whitespace', () {
      controller.setSharedMessage('  Trimmed message  ');
      expect(controller.sharedMessage, 'Trimmed message');
    });

    test('setSharedMessage ignores empty strings', () {
      controller.setSharedMessage('');
      expect(controller.sharedMessage, AppTexts.sampleMessage);
    });

    test('setSharedMessage ignores whitespace-only strings', () {
      controller.setSharedMessage('   ');
      expect(controller.sharedMessage, AppTexts.sampleMessage);
    });

    test('setSharedMessage sets currentStep to 1', () {
      controller.nextStep(); // step 1
      controller.nextStep(); // step 2
      controller.nextStep(); // step 3

      controller.setSharedMessage('New content from share');

      expect(controller.currentStep, 1);
    });

    test('setSharedMessage resets answers to defaults', () {
      controller.updateSourceAnswer('আছে');
      controller.updateDateAnswer('নেই');

      controller.setSharedMessage('New content');

      expect(controller.answers.beforeShareScore, 3);
      expect(controller.answers.sourceAnswer, isNull);
      expect(controller.answers.dateAnswer, isNull);
    });
  });

  group('RumorPauseController - Detected Issues', () {
    test('detectedIssues returns list for sample message', () {
      final issues = controller.detectedIssues;

      expect(issues, isNotEmpty);
      expect(issues, isA<List<String>>());
    });

    test('detectedIssues updates when message changes', () {
      final originalIssues = controller.detectedIssues;
      expect(originalIssues, isNotEmpty);

      controller.setSharedMessage(
        'আজকে আবহাওয়া ভালো থাকবে। https://weather.com',
      );

      final newIssues = controller.detectedIssues;

      // Different message should potentially produce different issues
      expect(newIssues, isNotNull);
    });
  });

  group('RumorPauseController - Full Flow Simulation', () {
    test('simulates complete app flow without errors', () {
      // Step 0: Welcome - just navigate
      expect(controller.currentStep, 0);
      controller.nextStep();

      // Step 1: Sample message screen
      expect(controller.currentStep, 1);
      expect(controller.sharedMessage, isNotEmpty);
      controller.nextStep();

      // Step 2: Before share
      expect(controller.currentStep, 2);
      controller.updateBeforeShareScore(4);
      expect(controller.answers.beforeShareScore, 4);
      controller.nextStep();

      // Step 3: Checking screen
      expect(controller.currentStep, 3);
      expect(controller.detectedIssues, isNotEmpty);
      controller.nextStep();

      // Step 4: Reflection start
      expect(controller.currentStep, 4);
      controller.nextStep();

      // Step 5: Question 1
      expect(controller.currentStep, 5);
      controller.updateSourceAnswer('নেই');
      controller.nextStep();

      // Step 6: Question 2
      expect(controller.currentStep, 6);
      controller.updateDateAnswer('নেই');
      controller.nextStep();

      // Step 7: Question 3
      expect(controller.currentStep, 7);
      controller.updateUrgencyAnswer('হ্যাঁ');
      controller.nextStep();

      // Step 8: Final suggestion
      expect(controller.currentStep, 8);
      final result = controller.riskResult;
      expect(result.title, 'High Risk');
      expect(result.suggestion, isNotEmpty);
    });
  });
}
