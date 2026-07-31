import 'package:flutter/material.dart';
import '../widgets/answer_option.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_page.dart';
import '../widgets/page_title.dart';

class QuestionScreen extends StatelessWidget {
  final int questionNumber;
  final String title;
  final String subtitle;
  final List<String> options;
  final String? selectedAnswer;
  final ValueChanged<String> onSelected;
  final VoidCallback? onNext;
  final VoidCallback onBack;
  final VoidCallback onReplayQuestion;

  const QuestionScreen({
    super.key,
    required this.questionNumber,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selectedAnswer,
    required this.onSelected,
    required this.onNext,
    required this.onBack,
    required this.onReplayQuestion,
  });

  @override
  Widget build(BuildContext context) {
    final actionGap = MediaQuery.sizeOf(context).height < 680 ? 20.0 : 28.0;

    return AppPage(
      onBack: onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepText(step: 'Question $questionNumber of 3'),
          const SizedBox(height: 12),
          PageTitle(title: title, subtitle: subtitle),
          const SizedBox(height: 30),
          ...options.map(
            (option) => AnswerOption(
              text: option,
              isSelected: selectedAnswer == option,
              onTap: () => onSelected(option),
            ),
          ),
          SizedBox(height: actionGap),
          SecondaryButton(
            text: '🔊 প্রশ্নটি আবার শুনুন',
            onPressed: onReplayQuestion,
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            text: questionNumber == 3 ? 'Result দেখুন' : 'পরবর্তী',
            icon: Icons.arrow_forward_rounded,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
