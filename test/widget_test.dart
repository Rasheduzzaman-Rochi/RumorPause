import 'package:flutter_test/flutter_test.dart';
import 'package:rumorpause/app/rumor_pause_app.dart';

void main() {
  testWidgets('shows Rumor Pause welcome screen', (tester) async {
    await tester.pumpWidget(const RumorPauseApp());

    expect(find.text('RumorPause'), findsOneWidget);
    expect(find.text('Share করার আগে একটু verify করুন'), findsOneWidget);
    expect(find.text('শুরু করুন'), findsOneWidget);
  });
}
