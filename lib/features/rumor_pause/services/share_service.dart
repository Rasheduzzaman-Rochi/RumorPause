import 'package:share_plus/share_plus.dart';

class ShareService {
  const ShareService();

  Future<void> shareCheckedContent({
    required String content,
  }) async {
    final String shareText =
        'আমি এটি RumorPause দিয়ে check করেছি। Source verify করে দেখুন:\n\n$content';

    await SharePlus.instance.share(
      ShareParams(
        text: shareText,
      ),
    );
  }
}