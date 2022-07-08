import 'package:teta_cms/teta_cms.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Use login with providers on different devices
class CMSPlatform {
  /// Use login with providers on different devices
  static Future login(
    final String url,
    final Function(String) callback,
  ) async {
    TetaCMS.log(url);
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
      await callback('');
    }
  }
}
