import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumorpause/app/rumor_pause_app.dart';
import 'package:rumorpause/core/constants/app_texts.dart';

/// Helper to scroll a widget into view and tap it.
Future<void> scrollAndTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('WelcomeScreen', () {
    testWidgets('shows app name and tagline', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      expect(find.text('RumorPause'), findsOneWidget);
      expect(find.text('Share করার আগে একটু verify করুন'), findsOneWidget);
    });

    testWidgets('shows info cards with descriptions', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      expect(find.text('এই app কী করবে?'), findsOneWidget);
      expect(find.text('Voice guide'), findsOneWidget);
    });

    testWidgets('shows start button', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      expect(find.text('শুরু করুন'), findsOneWidget);
    });

    testWidgets('shows verified user icon', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);
    });

    testWidgets('has no back button on welcome screen', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      expect(find.text('Back'), findsNothing);
    });
  });

  group('Screen Navigation - Full Flow', () {
    testWidgets('navigates from Welcome to Sample Message screen',
        (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));

      expect(find.text('Step 1 of 7'), findsOneWidget);
      expect(find.text('একটি message দেখুন'), findsOneWidget);
    });

    testWidgets('Sample Message screen shows sample message content',
        (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));

      expect(find.textContaining('জরুরি খবর'), findsOneWidget);
    });

    testWidgets('Sample Message screen shows back button', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));

      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('navigates to Before Share screen', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));

      expect(find.text('Step 2 of 7'), findsOneWidget);
      expect(find.text('Share করার আগে আপনার মতামত'), findsOneWidget);
    });

    testWidgets('Before Share screen has a slider', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('navigates to Checking screen', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));

      expect(find.text('Step 3 of 7'), findsOneWidget);
      expect(find.text('Message Checking'), findsOneWidget);
    });

    testWidgets('Checking screen shows detected issues', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));

      expect(find.text('Detected Issues'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsWidgets);
    });

    testWidgets('navigates to Reflection Start screen', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));
      await scrollAndTap(tester, find.text('Continue Reflection'));

      expect(find.text('Step 4 of 7'), findsOneWidget);
      expect(find.text('Share করার আগে একটু ভাবুন'), findsOneWidget);
      expect(find.text('Voice Guide'), findsOneWidget);
    });

    testWidgets('Reflection screen shows voice replay button', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));
      await scrollAndTap(tester, find.text('Continue Reflection'));

      await tester.ensureVisible(find.text('🔊 আবার শুনুন'));
      await tester.pumpAndSettle();
      expect(find.text('🔊 আবার শুনুন'), findsOneWidget);
      expect(find.text('প্রশ্ন শুরু করুন'), findsOneWidget);
    });

    testWidgets('shows reflection voice text on screen', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));
      await scrollAndTap(tester, find.text('Continue Reflection'));

      expect(
        find.textContaining(AppTexts.reflectionVoiceText),
        findsOneWidget,
      );
    });

    testWidgets('navigates to Question 1 screen', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));
      await scrollAndTap(tester, find.text('Continue Reflection'));
      await scrollAndTap(tester, find.text('প্রশ্ন শুরু করুন'));

      expect(find.text('Question 1 of 3'), findsOneWidget);
      expect(find.text('এই message-এ trusted source আছে কি?'), findsOneWidget);
    });

    testWidgets('Question 1 shows three answer options', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));
      await scrollAndTap(tester, find.text('Continue Reflection'));
      await scrollAndTap(tester, find.text('প্রশ্ন শুরু করুন'));

      expect(find.text('আছে'), findsOneWidget);
      expect(find.text('নেই'), findsOneWidget);
      expect(find.text('নিশ্চিত না'), findsOneWidget);
    });

    testWidgets('Question screen shows voice replay button', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));
      await scrollAndTap(tester, find.text('Continue Reflection'));
      await scrollAndTap(tester, find.text('প্রশ্ন শুরু করুন'));

      await tester.ensureVisible(find.text('🔊 প্রশ্নটি আবার শুনুন'));
      await tester.pumpAndSettle();
      expect(find.text('🔊 প্রশ্নটি আবার শুনুন'), findsOneWidget);
    });

    testWidgets('can select answer and navigate to Question 2',
        (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));
      await scrollAndTap(tester, find.text('Continue Reflection'));
      await scrollAndTap(tester, find.text('প্রশ্ন শুরু করুন'));

      // Select an answer
      await scrollAndTap(tester, find.text('নেই'));

      // Navigate to next question
      await scrollAndTap(tester, find.text('পরবর্তী'));

      expect(find.text('Question 2 of 3'), findsOneWidget);
    });

    testWidgets('full flow to Final Suggestion screen', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      // Welcome -> Sample Message
      await scrollAndTap(tester, find.text('শুরু করুন'));

      // Sample Message -> Before Share
      await scrollAndTap(tester, find.text('পরবর্তী'));

      // Before Share -> Checking
      await scrollAndTap(tester, find.text('Message Check করুন'));

      // Checking -> Reflection
      await scrollAndTap(tester, find.text('Continue Reflection'));

      // Reflection -> Question 1
      await scrollAndTap(tester, find.text('প্রশ্ন শুরু করুন'));

      // Question 1: select and next
      await scrollAndTap(tester, find.text('নেই'));
      await scrollAndTap(tester, find.text('পরবর্তী'));

      // Question 2: select and next
      expect(find.text('Question 2 of 3'), findsOneWidget);
      await scrollAndTap(tester, find.text('নেই'));
      await scrollAndTap(tester, find.text('পরবর্তী'));

      // Question 3: select and view result
      expect(find.text('Question 3 of 3'), findsOneWidget);
      await scrollAndTap(tester, find.text('হ্যাঁ'));
      await scrollAndTap(tester, find.text('Result দেখুন'));

      // Final Suggestion screen
      expect(find.text('Final Step'), findsOneWidget);
      expect(find.text('Final Suggestion'), findsOneWidget);
      expect(find.text('High Risk'), findsOneWidget);
    });

    testWidgets('Final Suggestion shows all action buttons', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      // Navigate through the full flow with safe answers
      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));
      await scrollAndTap(tester, find.text('Continue Reflection'));
      await scrollAndTap(tester, find.text('প্রশ্ন শুরু করুন'));
      await scrollAndTap(tester, find.text('আছে'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('আছে'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('না'));
      await scrollAndTap(tester, find.text('Result দেখুন'));

      // Verify final screen elements
      expect(find.text('Final Step'), findsOneWidget);

      await tester.ensureVisible(find.text('Share Safely'));
      await tester.pumpAndSettle();
      expect(find.text('Share Safely'), findsOneWidget);

      await tester.ensureVisible(find.text('Survey দিন'));
      await tester.pumpAndSettle();
      expect(find.text('Survey দিন'), findsOneWidget);

      await tester.ensureVisible(find.text('আবার শুরু করুন'));
      await tester.pumpAndSettle();
      expect(find.text('আবার শুরু করুন'), findsOneWidget);
    });

    testWidgets('Final Suggestion shows answer summary', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      // Navigate through the full flow
      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));
      await scrollAndTap(tester, find.text('Continue Reflection'));
      await scrollAndTap(tester, find.text('প্রশ্ন শুরু করুন'));
      await scrollAndTap(tester, find.text('আছে'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('আছে'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('না'));
      await scrollAndTap(tester, find.text('Result দেখুন'));

      // Scroll to Your Answers section
      await tester.ensureVisible(find.text('Your Answers'));
      await tester.pumpAndSettle();

      expect(find.text('Your Answers'), findsOneWidget);
      expect(find.text('Before check share score'), findsOneWidget);
      expect(find.text('Trusted source'), findsOneWidget);
      expect(find.text('Date / official link'), findsOneWidget);
      expect(find.text('Fear / urgency'), findsOneWidget);
    });

    testWidgets('back button navigates to previous screen', (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      // Go to Step 1
      await scrollAndTap(tester, find.text('শুরু করুন'));
      expect(find.text('Step 1 of 7'), findsOneWidget);

      // Go back to welcome using the back IconButton
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.text('RumorPause'), findsOneWidget);
    });


    testWidgets('restart from Final Suggestion goes back to welcome',
        (tester) async {
      await tester.pumpWidget(const RumorPauseApp());

      // Navigate through full flow
      await scrollAndTap(tester, find.text('শুরু করুন'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('Message Check করুন'));
      await scrollAndTap(tester, find.text('Continue Reflection'));
      await scrollAndTap(tester, find.text('প্রশ্ন শুরু করুন'));
      await scrollAndTap(tester, find.text('নেই'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('নেই'));
      await scrollAndTap(tester, find.text('পরবর্তী'));
      await scrollAndTap(tester, find.text('হ্যাঁ'));
      await scrollAndTap(tester, find.text('Result দেখুন'));

      // Tap restart
      await scrollAndTap(tester, find.text('আবার শুরু করুন'));

      // Should be back at welcome
      expect(find.text('RumorPause'), findsOneWidget);
      expect(find.text('শুরু করুন'), findsOneWidget);
    });
  });
}
