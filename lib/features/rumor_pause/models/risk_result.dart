import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum RiskLevel { low, medium, high }

class RiskResult {
  final int score;
  final RiskLevel level;
  final String title;
  final String suggestion;

  const RiskResult({
    required this.score,
    required this.level,
    required this.title,
    required this.suggestion,
  });

  Color get color {
    switch (level) {
      case RiskLevel.high:
        return AppColors.danger;
      case RiskLevel.medium:
        return AppColors.warning;
      case RiskLevel.low:
        return AppColors.success;
    }
  }
}
