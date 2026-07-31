import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 360;

    return Padding(
      padding: EdgeInsets.only(bottom: isCompact ? 10 : 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(isCompact ? 14 : 18),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 14 : 18,
            vertical: isCompact ? 14 : 18,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : Colors.white,
            borderRadius: BorderRadius.circular(isCompact ? 14 : 18),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
              SizedBox(width: isCompact ? 10 : 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: isCompact ? 18 : 20,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
