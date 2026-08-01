import 'package:flutter_test/flutter_test.dart';
import 'package:rumorpause/core/constants/app_texts.dart';
import 'package:rumorpause/features/rumor_pause/models/reflection_answers.dart';
import 'package:rumorpause/features/rumor_pause/models/risk_result.dart';
import 'package:rumorpause/features/rumor_pause/services/risk_analyzer_service.dart';

void main() {
  const service = RiskAnalyzerService();

  group('RiskAnalyzerService - analyze()', () {
    test('returns high risk for sample message with all negative answers', () {
      final result = service.analyze(
        message: AppTexts.sampleMessage,
        answers: const ReflectionAnswers(
          beforeShareScore: 5,
          sourceAnswer: 'নেই',
          dateAnswer: 'নেই',
          urgencyAnswer: 'হ্যাঁ',
        ),
      );

      expect(result.level, RiskLevel.high);
      expect(result.score, greaterThanOrEqualTo(8));
      expect(result.title, 'High Risk');
      expect(result.suggestion, isNotEmpty);
    });

    test('returns low risk for clean message with all positive answers', () {
      final result = service.analyze(
        message: 'আজকে আবহাওয়া ভালো থাকবে।',
        answers: const ReflectionAnswers(
          beforeShareScore: 2,
          sourceAnswer: 'আছে',
          dateAnswer: 'আছে',
          urgencyAnswer: 'না',
        ),
      );

      expect(result.level, RiskLevel.low);
      expect(result.score, lessThan(5));
      expect(result.title, 'Low Risk');
    });

    test('adds score for source answer নিশ্চিত না', () {
      final result = service.analyze(
        message: 'সাধারণ message',
        answers: const ReflectionAnswers(
          beforeShareScore: 3,
          sourceAnswer: 'নিশ্চিত না',
          dateAnswer: 'আছে',
          urgencyAnswer: 'না',
        ),
      );

      expect(result.score, greaterThanOrEqualTo(2));
    });

    test('adds score for date answer নিশ্চিত না', () {
      final result = service.analyze(
        message: 'সাধারণ message',
        answers: const ReflectionAnswers(
          beforeShareScore: 3,
          sourceAnswer: 'আছে',
          dateAnswer: 'নিশ্চিত না',
          urgencyAnswer: 'না',
        ),
      );

      expect(result.score, greaterThanOrEqualTo(2));
    });

    test('adds score for urgency answer হ্যাঁ', () {
      final result = service.analyze(
        message: 'সাধারণ message',
        answers: const ReflectionAnswers(
          beforeShareScore: 3,
          sourceAnswer: 'আছে',
          dateAnswer: 'আছে',
          urgencyAnswer: 'হ্যাঁ',
        ),
      );

      expect(result.score, greaterThanOrEqualTo(2));
    });

    test('handles null answers gracefully', () {
      final result = service.analyze(
        message: 'Test message',
        answers: const ReflectionAnswers(beforeShareScore: 3),
      );

      expect(result.level, isNotNull);
      expect(result.title, isNotEmpty);
      expect(result.suggestion, isNotEmpty);
    });

    test('riskResult updates dynamically as answers change', () {
      final lowResult = service.analyze(
        message: AppTexts.sampleMessage,
        answers: const ReflectionAnswers(
          beforeShareScore: 2,
          sourceAnswer: 'আছে',
          dateAnswer: 'আছে',
          urgencyAnswer: 'না',
        ),
      );

      final highResult = service.analyze(
        message: AppTexts.sampleMessage,
        answers: const ReflectionAnswers(
          beforeShareScore: 5,
          sourceAnswer: 'নেই',
          dateAnswer: 'নেই',
          urgencyAnswer: 'হ্যাঁ',
        ),
      );

      expect(highResult.score, greaterThan(lowResult.score));
    });
  });

  group('RiskAnalyzerService - detectIssues()', () {
    test('detects urgency language in sample message', () {
      final issues = service.detectIssues(AppTexts.sampleMessage);

      // The sample message contains urgency words like পাঠিয়ে দিন
      expect(issues.length, greaterThan(1));
    });

    test('detects fear language in sample message', () {
      // Use the actual sample message which contains ক্ষতি
      final issues = service.detectIssues(AppTexts.sampleMessage);

      // Sample message has fear word ক্ষতি
      expect(
        issues.any((issue) => issue.contains('ভয়') || issue.contains('ক্ষতি')),
        isTrue,
      );
    });

    test('detects official claim without URL in sample message', () {
      final issues = service.detectIssues(AppTexts.sampleMessage);

      // Sample message claims সরকার ঘোষণা but has no URL
      expect(
        issues.any((issue) => issue.contains('Official claim')),
        isTrue,
      );
    });

    test('does not flag official claim when URL is present', () {
      // Use actual text from sample message with a URL appended
      final message = '${AppTexts.sampleMessage} https://example.gov.bd';
      final issues = service.detectIssues(message);

      expect(
        issues.any((issue) => issue.contains('Official claim')),
        isFalse,
      );
    });

    test('detects missing source/official link', () {
      final issues = service.detectIssues('কিছু একটা হয়েছে।');

      expect(
        issues.any((issue) => issue.contains('Source')),
        isTrue,
      );
    });

    test('detects YouTube link', () {
      final issues = service.detectIssues(
        'এই ভিডিওটি দেখুন https://youtube.com/watch?v=123',
      );

      expect(
        issues.any((issue) => issue.contains('YouTube')),
        isTrue,
      );
    });

    test('detects youtu.be short link', () {
      final issues = service.detectIssues('https://youtu.be/abc123');

      expect(
        issues.any((issue) => issue.contains('YouTube')),
        isTrue,
      );
    });

    test('detects Facebook link', () {
      final issues = service.detectIssues(
        'দেখুন https://facebook.com/post/123',
      );

      expect(
        issues.any((issue) => issue.contains('Facebook')),
        isTrue,
      );
    });

    test('detects fb.watch link', () {
      final issues = service.detectIssues('ভিডিও: https://fb.watch/abc');

      expect(
        issues.any((issue) => issue.contains('Facebook')),
        isTrue,
      );
    });

    test('returns default message when no red flags found', () {
      final issues = service.detectIssues(
        'আজ আবহাওয়া ভালো। https://weather.com/bd',
      );

      expect(issues.length, 1);
      expect(issues.first, contains('warning sign'));
    });

    test('detects multiple issues from sample message', () {
      final issues = service.detectIssues(AppTexts.sampleMessage);

      // Sample message has urgency, fear, official claim, no link
      expect(issues.length, greaterThanOrEqualTo(3));
    });
  });
}
