import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_texts.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_page.dart';
import '../widgets/page_title.dart';

class ReflectionStartScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onReplayVoice;

  const ReflectionStartScreen({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.onReplayVoice,
  });

  @override
  Widget build(BuildContext context) {
    final actionGap = MediaQuery.sizeOf(context).height < 680 ? 20.0 : 28.0;

    return AppPage(
      onBack: onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepText(step: 'Step 4 of 7'),
          const SizedBox(height: 12),
          const PageTitle(
            title: 'Share করার আগে একটু ভাবুন',
            subtitle:
                'এখন app আপনাকে ৩টি সহজ প্রশ্ন করবে। এগুলো answer করলে আপনি বুঝতে পারবেন message টি verify করা দরকার কি না।',
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFC8E6C9)),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.record_voice_over_rounded,
                  size: 56,
                  color: AppColors.primary,
                ),
                SizedBox(height: 18),
                Text(
                  'Voice Guide',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF102A13),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '“${AppTexts.reflectionVoiceText}”',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.45,
                    color: Color(0xFF263238),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SecondaryButton(text: '🔊 আবার শুনুন', onPressed: onReplayVoice),
          SizedBox(height: actionGap),
          PrimaryButton(
            text: 'প্রশ্ন শুরু করুন',
            icon: Icons.arrow_forward_rounded,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
