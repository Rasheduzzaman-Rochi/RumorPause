import 'package:flutter_test/flutter_test.dart';
import 'package:rumorpause/features/rumor_pause/models/reflection_answers.dart';

void main() {
  group('ReflectionAnswers', () {
    test('creates with required beforeShareScore and null optional fields', () {
      const answers = ReflectionAnswers(beforeShareScore: 3);

      expect(answers.beforeShareScore, 3);
      expect(answers.sourceAnswer, isNull);
      expect(answers.dateAnswer, isNull);
      expect(answers.urgencyAnswer, isNull);
    });

    test('creates with all fields provided', () {
      const answers = ReflectionAnswers(
        beforeShareScore: 5,
        sourceAnswer: 'আছে',
        dateAnswer: 'নেই',
        urgencyAnswer: 'হ্যাঁ',
      );

      expect(answers.beforeShareScore, 5);
      expect(answers.sourceAnswer, 'আছে');
      expect(answers.dateAnswer, 'নেই');
      expect(answers.urgencyAnswer, 'হ্যাঁ');
    });

    test('copyWith updates only specified fields', () {
      const original = ReflectionAnswers(beforeShareScore: 3);

      final updated = original.copyWith(sourceAnswer: 'নেই');

      expect(updated.beforeShareScore, 3);
      expect(updated.sourceAnswer, 'নেই');
      expect(updated.dateAnswer, isNull);
      expect(updated.urgencyAnswer, isNull);
    });

    test('copyWith preserves existing values when not overridden', () {
      const original = ReflectionAnswers(
        beforeShareScore: 4,
        sourceAnswer: 'আছে',
        dateAnswer: 'আছে',
        urgencyAnswer: 'না',
      );

      final updated = original.copyWith(beforeShareScore: 2);

      expect(updated.beforeShareScore, 2);
      expect(updated.sourceAnswer, 'আছে');
      expect(updated.dateAnswer, 'আছে');
      expect(updated.urgencyAnswer, 'না');
    });

    test('copyWith can update all fields at once', () {
      const original = ReflectionAnswers(beforeShareScore: 1);

      final updated = original.copyWith(
        beforeShareScore: 5,
        sourceAnswer: 'আছে',
        dateAnswer: 'নেই',
        urgencyAnswer: 'হ্যাঁ',
      );

      expect(updated.beforeShareScore, 5);
      expect(updated.sourceAnswer, 'আছে');
      expect(updated.dateAnswer, 'নেই');
      expect(updated.urgencyAnswer, 'হ্যাঁ');
    });

    test('copyWith returns new instance (does not mutate original)', () {
      const original = ReflectionAnswers(beforeShareScore: 3);

      final updated = original.copyWith(sourceAnswer: 'নেই');

      expect(original.sourceAnswer, isNull);
      expect(updated.sourceAnswer, 'নেই');
    });
  });
}
