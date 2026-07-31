import 'package:flutter/material.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_cards.dart';
import '../widgets/app_page.dart';
import '../widgets/page_title.dart';

class SampleMessageScreen extends StatelessWidget {
  final String message;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const SampleMessageScreen({
    super.key,
    required this.message,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppPage(
      onBack: onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepText(step: 'Step 1 of 7'),
          const SizedBox(height: 12),
          const PageTitle(
            title: 'একটি message দেখুন',
            subtitle:
                'ধরুন আপনি Facebook বা Messenger থেকে এই message টি share করতে যাচ্ছেন।',
          ),
          const SizedBox(height: 24),
          MessageCard(message: message),
          const SizedBox(height: 18),
          const InfoCard(
            icon: Icons.lightbulb_outline_rounded,
            title: 'আপনার কাজ',
            text:
                'প্রথমে ভাবুন, আপনি এই message টি share করবেন কি না। তারপর app check শুরু করবে।',
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            text: 'পরবর্তী',
            icon: Icons.arrow_forward_rounded,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
