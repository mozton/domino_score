import 'package:dominos_score/domain/datasourse/url_launcher_data_source.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherDataSourceImpl implements UrlLauncherDataSource {
  @override
  Future<void> openInstagram() async {
    final webUrl =
        'https://www.instagram.com/corilloapp?igsh=MWpkdTNzbW43MXM0OQ==';

    final Uri aboutthisAppUrl = Uri.parse(webUrl);

    await launchUrl(aboutthisAppUrl);
  }
}
