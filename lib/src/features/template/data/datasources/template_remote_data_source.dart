import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/services/url_launcher_gateway/url_launcher_gateway.dart';

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
    try {
      final link = 'https://github.com/MaeAuliya';

      final uriLink = Uri.parse(link);

      if (await _urlLauncherGateway.canLaunch(uriLink)) {
        final isLaunch = await _urlLauncherGateway.launch(
          uriLink,
          mode: LaunchMode.externalApplication,
        );

        if (!isLaunch) {
          throw const ServerException(
            message: 'Could`nt open Github',
            statusCode: 599,
          );
        }
      } else {
        throw const ServerException(
          message: 'Could`nt open Github',
          statusCode: 599,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 599);
    }
  }
}
