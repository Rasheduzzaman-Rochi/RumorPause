import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_cards.dart';
import '../widgets/app_page.dart';
import '../widgets/page_title.dart';

class CheckingScreen extends StatelessWidget {
  final String message;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CheckingScreen({
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
          const StepText(step: 'Step 3 of 7'),
          const SizedBox(height: 12),
          const PageTitle(
            title: 'Message Checking',
            subtitle:
                'Prototype version-এ simple rule-based checking দেখানো হচ্ছে।',
          ),
          const SizedBox(height: 24),
          MessageCard(message: message),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: cardDecoration(),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                    SizedBox(width: 8),
                    Text(
                      'Detected Issues',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                IssueItem(text: 'Trusted source পাওয়া যায়নি'),
                IssueItem(text: 'Message-এ urgency/fear language আছে'),
                IssueItem(text: 'Official date বা reliable link পরিষ্কার না'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            text: 'Voice Guide শুনুন',
            icon: Icons.volume_up_rounded,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
