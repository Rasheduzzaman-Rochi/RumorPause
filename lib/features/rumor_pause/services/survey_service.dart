import 'package:url_launcher/url_launcher.dart';

class SurveyService {
  const SurveyService();

  Future<bool> openSurveyForm(String url) async {
    final Uri uri = Uri.parse(url);

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}