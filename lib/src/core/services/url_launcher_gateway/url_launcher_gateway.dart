import 'package:url_launcher/url_launcher.dart';

abstract class UrlLauncherGateway {
  const UrlLauncherGateway();

  Future<bool> canLaunch(Uri uri);

  Future<bool> launch(Uri uri, {LaunchMode mode});
}

class UrlLauncherGatewayImpl implements UrlLauncherGateway {
  @override
  Future<bool> canLaunch(Uri uri) => canLaunchUrl(uri);

  @override
  Future<bool> launch(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) => launch(uri, mode: mode);
}
