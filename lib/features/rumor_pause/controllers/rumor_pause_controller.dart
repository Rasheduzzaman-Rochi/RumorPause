import '../../../../core/constants/app_texts.dart';
import '../models/reflection_answers.dart';
import '../models/risk_result.dart';
import '../services/risk_analyzer_service.dart';

class RumorPauseController {
  RumorPauseController({
    RiskAnalyzerService riskAnalyzerService = const RiskAnalyzerService(),
  }) : _riskAnalyzerService = riskAnalyzerService;

  final RiskAnalyzerService _riskAnalyzerService;

  int currentStep = 0;

  String sharedMessage = AppTexts.sampleMessage;

  ReflectionAnswers answers = const ReflectionAnswers(beforeShareScore: 3);

  void nextStep() {
    currentStep++;
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
    }
  }

  void restart() {
    currentStep = 0;
    sharedMessage = AppTexts.sampleMessage;
    answers = const ReflectionAnswers(beforeShareScore: 3);
  }

  void updateBeforeShareScore(int score) {
    answers = answers.copyWith(beforeShareScore: score);
  }

  void updateSourceAnswer(String answer) {
    answers = answers.copyWith(sourceAnswer: answer);
  }

  void updateDateAnswer(String answer) {
    answers = answers.copyWith(dateAnswer: answer);
  }

  void updateUrgencyAnswer(String answer) {
    answers = answers.copyWith(urgencyAnswer: answer);
  }

  RiskResult get riskResult {
    return _riskAnalyzerService.analyze(
      message: sharedMessage,
      answers: answers,
    );
  }

  void setSharedMessage(String message) {
    final String cleanMessage = message.trim();

    if (cleanMessage.isEmpty) return;

    sharedMessage = cleanMessage;

    answers = const ReflectionAnswers(
      beforeShareScore: 3,
    );

    // When content is received from another app,
    // start from the screen where the shared content is shown.
    currentStep = 1;
  }

  List<String> get detectedIssues {
    return _riskAnalyzerService.detectIssues(sharedMessage);
  }
}
