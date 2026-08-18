import 'package:url_launcher/url_launcher.dart' show LaunchMode;

import '../../../../core/errors/exception.dart';
import '../../../../core/services/url_launcher_gateway/url_launcher_gateway.dart';
import '../../../../core/utils/constants.dart';

abstract class TemplateRemoteDataSource {
  const TemplateRemoteDataSource();

  Future<void> openGithubUrl();
}

class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  final UrlLauncherGateway _urlLauncherGateway;

  const TemplateRemoteDataSourceImpl({
    required UrlLauncherGateway urlLauncherGateway,
  }) : _urlLauncherGateway = urlLauncherGateway;

  @override
  Future<void> openGithubUrl() async {
    final uri = Uri.parse(Constants.githubUrl);

    try {
      if (!await _urlLauncherGateway.canLaunch(uri)) {
        throw const ServerException.rejected(
          diagnosticMessage: 'GitHub URL cannot be launched',
        );
      }

      final launched = await _urlLauncherGateway.launch(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw const ServerException.rejected(
          diagnosticMessage: 'GitHub URL launch returned false',
        );
      }
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const ServerException.rejected(
        diagnosticMessage: 'GitHub URL gateway failed',
      );
    }
  }
}
