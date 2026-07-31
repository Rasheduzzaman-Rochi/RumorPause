import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/reflection_answers.dart';
import '../models/risk_result.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_cards.dart';
import '../widgets/app_page.dart';
import '../widgets/page_title.dart';

class FinalSuggestionScreen extends StatelessWidget {
  final String message;
  final ReflectionAnswers answers;
  final RiskResult riskResult;
  final VoidCallback onBack;
  final VoidCallback onRestart;
  final VoidCallback onReplaySuggestion;
  final VoidCallback onOpenSurvey;
  final VoidCallback onShareSafely;

  const FinalSuggestionScreen({
    super.key,
    required this.message,
    required this.answers,
    required this.riskResult,
    required this.onBack,
    required this.onRestart,
    required this.onReplaySuggestion,
    required this.onOpenSurvey,
    required this.onShareSafely,
  });

  @override
  Widget build(BuildContext context) {
    final actionGap = MediaQuery.sizeOf(context).height < 680 ? 20.0 : 28.0;

    return AppPage(
      onBack: onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepText(step: 'Final Step'),
          const SizedBox(height: 12),
          const PageTitle(
            title: 'Final Suggestion',
            subtitle:
                'আপনার answer এবং message-এর warning sign দেখে suggestion দেখানো হচ্ছে।',
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: riskResult.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: riskResult.color.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  riskResult.level == RiskLevel.high
                      ? Icons.report_problem_rounded
                      : Icons.info_rounded,
                  color: riskResult.color,
                  size: 46,
                ),
                const SizedBox(height: 14),
                Text(
                  riskResult.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: riskResult.color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  riskResult.suggestion,
                  style: const TextStyle(
                    fontSize: 19,
                    height: 1.45,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SecondaryButton(
            text: '🔊 Suggestion আবার শুনুন',
            onPressed: onReplaySuggestion,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Answers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                _ResultRow(
                  label: 'Before check share score',
                  value: '${answers.beforeShareScore} / 5',
                ),
                _ResultRow(
                  label: 'Trusted source',
                  value: answers.sourceAnswer ?? '-',
                ),
                _ResultRow(
                  label: 'Date / official link',
                  value: answers.dateAnswer ?? '-',
                ),
                _ResultRow(
                  label: 'Fear / urgency',
                  value: answers.urgencyAnswer ?? '-',
                ),
              ],
            ),
          ),
          SizedBox(height: actionGap),
          PrimaryButton(
            text: 'Share Safely',
            icon: Icons.share_rounded,
            onPressed: onShareSafely,
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            text: 'Survey দিন',
            onPressed: onOpenSurvey,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRestart,
            child: const Center(
              child: Text('আবার শুরু করুন', style: TextStyle(fontSize: 17)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16.5,
                color: AppColors.textMedium,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
