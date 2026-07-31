import 'package:flutter/material.dart';
import '../../../../core/constants/app_texts.dart';
import '../controllers/rumor_pause_controller.dart';
import '../services/voice_service.dart';
import 'before_share_screen.dart';
import 'checking_screen.dart';
import 'final_suggestion_screen.dart';
import 'question_screen.dart';
import 'reflection_start_screen.dart';
import 'sample_message_screen.dart';
import 'welcome_screen.dart';
import '../services/survey_service.dart';
import '../services/share_service.dart';
import '../services/share_receiver_service.dart';

class RumorPauseFlowScreen extends StatefulWidget {
  const RumorPauseFlowScreen({super.key});

  @override
  State<RumorPauseFlowScreen> createState() => _RumorPauseFlowScreenState();
}

class _RumorPauseFlowScreenState extends State<RumorPauseFlowScreen> {
  final RumorPauseController controller = RumorPauseController();
  final VoiceService voiceService = VoiceService();
  final SurveyService surveyService = const SurveyService();
  final ShareService shareService = const ShareService();
  final ShareReceiverService shareReceiverService = ShareReceiverService();
  @override
  void initState() {
    super.initState();
    voiceService.init();
    _setupShareReceiving();
  }

  @override
  void dispose() {
    shareReceiverService.dispose();
    voiceService.dispose();
    super.dispose();
  }

  void _next() {
    voiceService.stop();
    setState(controller.nextStep);
    // setState(controller.nextStep);
    // _speakForCurrentStep();
  }

  void _back() {
    voiceService.stop();
    setState(controller.previousStep);
  }

  void _restart() {
    voiceService.stop();
    setState(controller.restart);
  }

  Future<void> _openSurveyForm() async {
    final bool opened = await surveyService.openSurveyForm(
      AppTexts.surveyFormUrl,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Survey form open করা যায়নি। Link check করুন।'),
        ),
      );
    }
  }

  Future<void> _shareSafely() async {
    await shareService.shareCheckedContent(
      content: controller.sharedMessage,
    );
  }

  void _setupShareReceiving() {
    shareReceiverService.listenForSharedContent(
      onContentReceived: _handleSharedContent,
    );

    shareReceiverService.checkInitialSharedContent(
      onContentReceived: _handleSharedContent,
    );
  }

  void _handleSharedContent(String content) {
    if (!mounted) return;

    voiceService.stop();

    setState(() {
      controller.setSharedMessage(content);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shared content RumorPause-এ এসেছে।'),
      ),
    );
  }

  Future<void> _speakForCurrentStep() async {
    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    switch (controller.currentStep) {
      case 4:
        await voiceService.speak(AppTexts.reflectionVoiceText);
        break;

      case 5:
        await voiceService.speak(
          'প্রথম প্রশ্ন। এই message-এ trusted source আছে কি?',
        );
        break;

      case 6:
        await voiceService.speak(
          'দ্বিতীয় প্রশ্ন। এই message-এ clear date বা official link আছে কি?',
        );
        break;

      case 7:
        await voiceService.speak(
          'তৃতীয় প্রশ্ন। Message-টি কি ভয় দেখিয়ে দ্রুত share করতে বলছে?',
        );
        break;

      case 8:
        await voiceService.speak(controller.riskResult.suggestion);
        break;

      default:
        break;
    }
  }

  Future<void> _speakReflectionGuide() async {
    await voiceService.speak(AppTexts.reflectionVoiceText);
  }

  Future<void> _speakQuestion(String question) async {
    await voiceService.speak(question);
  }

  Future<void> _speakFinalSuggestion() async {
    await voiceService.speak(controller.riskResult.suggestion);
  }

  @override
  Widget build(BuildContext context) {
    switch (controller.currentStep) {
      case 0:
        return WelcomeScreen(onNext: _next);

      case 1:
        return SampleMessageScreen(
          message: controller.sharedMessage,
          onNext: _next,
          onBack: _back,
        );

      case 2:
        return BeforeShareScreen(
          selectedValue: controller.answers.beforeShareScore,
          onChanged: (value) {
            setState(() => controller.updateBeforeShareScore(value));
          },
          onNext: _next,
          onBack: _back,
        );

      case 3:
        return CheckingScreen(
          message: controller.sharedMessage,
          detectedIssues: controller.detectedIssues,
          onNext: _next,
          onBack: _back,
        );

      case 4:
        return ReflectionStartScreen(
          onNext: _next,
          onBack: _back,
          onReplayVoice: _speakReflectionGuide,
        );

      case 5:
        return QuestionScreen(
          questionNumber: 1,
          title: 'এই message-এ trusted source আছে কি?',
          subtitle: 'যেমন official page, news source, বা reliable person.',
          options: const ['আছে', 'নেই', 'নিশ্চিত না'],
          selectedAnswer: controller.answers.sourceAnswer,
          onSelected: (answer) {
            setState(() => controller.updateSourceAnswer(answer));
          },
          onNext: controller.answers.sourceAnswer == null ? null : _next,
          onBack: _back,
          onReplayQuestion: () => _speakQuestion(
            'প্রথম প্রশ্ন। এই message-এ trusted source আছে কি?',
          ),
        );

      case 6:
        return QuestionScreen(
          questionNumber: 2,
          title: 'এই message-এ clear date বা official link আছে কি?',
          subtitle: 'যেমন তারিখ, website link, বা official notice.',
          options: const ['আছে', 'নেই', 'নিশ্চিত না'],
          selectedAnswer: controller.answers.dateAnswer,
          onSelected: (answer) {
            setState(() => controller.updateDateAnswer(answer));
          },
          onNext: controller.answers.dateAnswer == null ? null : _next,
          onBack: _back,
          onReplayQuestion: () => _speakQuestion(
            'দ্বিতীয় প্রশ্ন। এই message-এ clear date বা official link আছে কি?',
          ),
        );

      case 7:
        return QuestionScreen(
          questionNumber: 3,
          title: 'Message-টি কি ভয় দেখিয়ে দ্রুত share করতে বলছে?',
          subtitle: 'যেমন “এখনই পাঠান”, “না হলে ক্ষতি হবে”, “সবাইকে জানান”.',
          options: const ['হ্যাঁ', 'না', 'নিশ্চিত না'],
          selectedAnswer: controller.answers.urgencyAnswer,
          onSelected: (answer) {
            setState(() => controller.updateUrgencyAnswer(answer));
          },
          onNext: controller.answers.urgencyAnswer == null ? null : _next,
          onBack: _back,
          onReplayQuestion: () => _speakQuestion(
            'তৃতীয় প্রশ্ন। Message-টি কি ভয় দেখিয়ে দ্রুত share করতে বলছে?',
          ),
        );

      default:
        return FinalSuggestionScreen(
          message: controller.sharedMessage,
          answers: controller.answers,
          riskResult: controller.riskResult,
          onBack: _back,
          onRestart: _restart,
          onReplaySuggestion: _speakFinalSuggestion,
          onOpenSurvey: _openSurveyForm,
          onShareSafely: _shareSafely,
        );
    }
  }
}