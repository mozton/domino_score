import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  Future<void> openInstagram() async {
    final webUrl =
        'https://www.instagram.com/corilloapp?igsh=MWpkdTNzbW43MXM0OQ==';
    await launchUrl(Uri.parse(webUrl));
  }
}
