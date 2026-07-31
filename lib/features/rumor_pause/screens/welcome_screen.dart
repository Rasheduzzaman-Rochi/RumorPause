import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_cards.dart';
import '../widgets/app_page.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomeScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).height < 680;

    return AppPage(
      showBack: false,
      child: Column(
        children: [
          SizedBox(height: isCompact ? 20 : 56),
          Center(
            child: Container(
              height: isCompact ? 72 : 90,
              width: isCompact ? 72 : 90,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(isCompact ? 22 : 28),
              ),
              child: Icon(
                Icons.verified_user_rounded,
                size: isCompact ? 42 : 50,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: isCompact ? 20 : 28),
          Text(
            'RumorPause',
            style: TextStyle(
              fontSize: isCompact ? 30 : 34,
              fontWeight: FontWeight.w800,
              color: Color(0xFF102A13),
            ),
          ),
          SizedBox(height: isCompact ? 8 : 12),
          Text(
            'Share করার আগে একটু verify করুন',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isCompact ? 16 : 18,
              color: AppColors.textMedium,
            ),
          ),
          SizedBox(height: isCompact ? 20 : 32),
          const InfoCard(
            icon: Icons.info_outline_rounded,
            title: 'এই app কী করবে?',
            text:
                'Online message বা link share করার আগে আপনাকে ৩০ সেকেন্ডের একটি simple check করতে সাহায্য করবে।',
          ),
          SizedBox(height: isCompact ? 10 : 14),
          const InfoCard(
            icon: Icons.record_voice_over_rounded,
            title: 'Voice guide',
            text: 'Prototype-এর পরের step-এ app Bangla voice instruction দিবে।',
          ),
          SizedBox(height: isCompact ? 24 : 40),
          PrimaryButton(
            text: 'শুরু করুন',
            icon: Icons.arrow_forward_rounded,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
