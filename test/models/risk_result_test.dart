import 'package:flutter_test/flutter_test.dart';
import 'package:rumorpause/core/constants/app_colors.dart';
import 'package:rumorpause/features/rumor_pause/models/risk_result.dart';

void main() {
  group('RiskResult', () {
    test('high risk returns danger color', () {
      const result = RiskResult(
        score: 10,
        level: RiskLevel.high,
        title: 'High Risk',
        suggestion: 'Test suggestion',
      );

      expect(result.color, AppColors.danger);
    });

    test('medium risk returns warning color', () {
      const result = RiskResult(
        score: 6,
        level: RiskLevel.medium,
        title: 'Medium Risk',
        suggestion: 'Test suggestion',
      );

      expect(result.color, AppColors.warning);
    });

    test('low risk returns success color', () {
      const result = RiskResult(
        score: 2,
        level: RiskLevel.low,
        title: 'Low Risk',
        suggestion: 'Test suggestion',
      );

      expect(result.color, AppColors.success);
    });

    test('stores all properties correctly', () {
      const result = RiskResult(
        score: 8,
        level: RiskLevel.high,
        title: 'High Risk',
        suggestion: 'Do not share',
      );

      expect(result.score, 8);
      expect(result.level, RiskLevel.high);
      expect(result.title, 'High Risk');
      expect(result.suggestion, 'Do not share');
    });
  });

  group('RiskLevel', () {
    test('has exactly 3 values', () {
      expect(RiskLevel.values.length, 3);
    });

    test('contains low, medium, high', () {
      expect(RiskLevel.values, contains(RiskLevel.low));
      expect(RiskLevel.values, contains(RiskLevel.medium));
      expect(RiskLevel.values, contains(RiskLevel.high));
    });
  });
}
