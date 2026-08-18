import 'package:url_launcher/url_launcher.dart' as launcher;

abstract class UrlLauncherGateway {
  const UrlLauncherGateway();

  Future<bool> canLaunch(Uri uri);

  Future<bool> launch(
    Uri uri, {
    launcher.LaunchMode mode = launcher.LaunchMode.platformDefault,
  });
}

class UrlLauncherGatewayImpl implements UrlLauncherGateway {
  const UrlLauncherGatewayImpl();

  @override
  Future<bool> canLaunch(Uri uri) => launcher.canLaunchUrl(uri);

  @override
  Future<bool> launch(
    Uri uri, {
    launcher.LaunchMode mode = launcher.LaunchMode.platformDefault,
  }) => launcher.launchUrl(uri, mode: mode);
}
