class ReflectionAnswers {
  final int beforeShareScore;
  final String? sourceAnswer;
  final String? dateAnswer;
  final String? urgencyAnswer;

  const ReflectionAnswers({
    required this.beforeShareScore,
    this.sourceAnswer,
    this.dateAnswer,
    this.urgencyAnswer,
  });

  ReflectionAnswers copyWith({
    int? beforeShareScore,
    String? sourceAnswer,
    String? dateAnswer,
    String? urgencyAnswer,
  }) {
    return ReflectionAnswers(
      beforeShareScore: beforeShareScore ?? this.beforeShareScore,
      sourceAnswer: sourceAnswer ?? this.sourceAnswer,
      dateAnswer: dateAnswer ?? this.dateAnswer,
      urgencyAnswer: urgencyAnswer ?? this.urgencyAnswer,
    );
  }
}
