import 'package:url_launcher/url_launcher.dart';

class SupportChannelLauncher {
  const SupportChannelLauncher({required String supportUrl})
    : _supportUrl = supportUrl;

  final String _supportUrl;

  Future<bool> openSupportChannel() {
    return launchUrl(
      Uri.parse(_supportUrl),
      mode: LaunchMode.externalApplication,
    );
  }
}
