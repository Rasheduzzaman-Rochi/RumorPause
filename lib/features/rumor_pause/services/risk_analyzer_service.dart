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
}
