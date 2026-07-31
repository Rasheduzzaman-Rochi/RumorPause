import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_cards.dart';
import '../widgets/app_page.dart';
import '../widgets/page_title.dart';

class BeforeShareScreen extends StatelessWidget {
  final int selectedValue;
  final ValueChanged<int> onChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BeforeShareScreen({
    super.key,
    required this.selectedValue,
    required this.onChanged,
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
          const StepText(step: 'Step 2 of 7'),
          const SizedBox(height: 12),
          const PageTitle(
            title: 'Share করার আগে আপনার মতামত',
            subtitle:
                'App check করার আগে আপনি কী সিদ্ধান্ত নিতেন, সেটা জানার জন্য এই প্রশ্ন।',
          ),
          const SizedBox(height: 26),
          const Text(
            'এই message দেখলে আপনি কি share করবেন?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: cardDecoration(),
            child: Column(
              children: [
                Slider(
                  value: selectedValue.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: selectedValue.toString(),
                  onChanged: (value) => onChanged(value.round()),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        '১\nএকদম share করবো না',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLight,
                          height: 1.3,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '৫\nঅবশ্যই share করবো',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLight,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'আপনার উত্তর: $selectedValue',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            text: 'Message Check করুন',
            icon: Icons.search_rounded,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
