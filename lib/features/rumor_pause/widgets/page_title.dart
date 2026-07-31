import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const PageTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isCompact ? 25 : 29,
            fontWeight: FontWeight.w900,
            color: AppColors.textDark,
            height: 1.15,
          ),
        ),
        SizedBox(height: isCompact ? 8 : 10),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: isCompact ? 16 : 18,
            height: 1.45,
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }
}

class StepText extends StatelessWidget {
  final String step;

  const StepText({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 360;

    return Text(
      step,
      style: TextStyle(
        fontSize: isCompact ? 14 : 15,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }
}
