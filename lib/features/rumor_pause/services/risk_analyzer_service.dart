import '../models/reflection_answers.dart';
import '../models/risk_result.dart';

class RiskAnalyzerService {
  const RiskAnalyzerService();

  RiskResult analyze({
    required String message,
    required ReflectionAnswers answers,
  }) {
    int score = 0;
    final lowerMessage = message.toLowerCase();

    final riskyWords = [
      'জরুরি',
      'আজ রাত',
      'সবাইকে',
      'পাঠিয়ে দিন',
      'ক্ষতি',
      'সরকার ঘোষণা',
    ];

    for (final word in riskyWords) {
      if (lowerMessage.contains(word)) {
        score++;
      }
    }

    if (answers.sourceAnswer == 'নেই' || answers.sourceAnswer == 'নিশ্চিত না') {
      score += 2;
    }

    if (answers.dateAnswer == 'নেই' || answers.dateAnswer == 'নিশ্চিত না') {
      score += 2;
    }

    if (answers.urgencyAnswer == 'হ্যাঁ') {
      score += 2;
    }

    if (score >= 8) {
      return RiskResult(
        score: score,
        level: RiskLevel.high,
        title: 'High Risk',
        suggestion:
            'এই message verify না করে share না করাই ভালো। আগে trusted source, official page, বা reliable news source check করুন।',
      );
    }

    if (score >= 5) {
      return RiskResult(
        score: score,
        level: RiskLevel.medium,
        title: 'Medium Risk',
        suggestion:
            'এই message share করার আগে source এবং official link check করা ভালো।',
      );
    }

    return RiskResult(
      score: score,
      level: RiskLevel.low,
      title: 'Low Risk',
      suggestion:
          'Risk কম মনে হলেও share করার আগে source check করা ভালো অভ্যাস।',
    );
  }

  List<String> detectIssues(String message) {
    final String text = message.toLowerCase();
    final List<String> issues = [];

    final bool hasUrl = text.contains('http://') ||
        text.contains('https://') ||
        text.contains('www.');
    final bool isYouTubeLink =
        text.contains('youtube.com') || text.contains('youtu.be');
    final bool isFacebookLink =
        text.contains('facebook.com') || text.contains('fb.watch');

    final List<String> urgencyWords = [
      'জরুরি',
      'এখনই',
      'আজ রাত',
      'দ্রুত',
      'সবাইকে পাঠান',
      'পাঠিয়ে দিন',
      'share করুন',
      'শেয়ার করুন',
      'ভাইরাল করুন',
    ];

    final List<String> fearWords = [
      'ক্ষতি',
      'বিপদ',
      'মারা যাবে',
      'ভয়ংকর',
      'সতর্কতা',
      'না হলে',
      'শেষ',
    ];

    final List<String> officialClaimWords = [
      'সরকার ঘোষণা',
      'সরকার বলেছে',
      'official',
      'অফিসিয়াল',
      'নোটিশ',
      'ঘোষণা দিয়েছে',
    ];

    final bool hasUrgency =
        urgencyWords.any((word) => text.contains(word.toLowerCase()));
    final bool hasFear =
        fearWords.any((word) => text.contains(word.toLowerCase()));
    final bool hasOfficialClaim =
        officialClaimWords.any((word) => text.contains(word.toLowerCase()));

    if (hasUrgency) {
      issues.add('Message-এ দ্রুত share করার চাপ আছে');
    }

    if (hasFear) {
      issues.add('Message-এ ভয় বা ক্ষতির ভাষা আছে');
    }

    if (hasOfficialClaim && !hasUrl) {
      issues.add('Official claim আছে, কিন্তু reliable link পাওয়া যায়নি');
    }

    if (!hasUrl) {
      issues.add('Source বা official link পরিষ্কার না');
    }

    if (isYouTubeLink) {
      issues.add(
          'YouTube link পাওয়া গেছে — share করার আগে channel/source check করা ভালো');
    }

    if (isFacebookLink) {
      issues.add(
          'Facebook link পাওয়া গেছে — post/page source verify করা ভালো');
    }

    if (issues.isEmpty) {
      issues.add(
          'বড় warning sign পাওয়া যায়নি, তবে share করার আগে source check করা ভালো');
    }

    return issues;
  }
}
