import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/errors/exception.dart';

abstract class TemplateRemoteDataSource {
  const TemplateRemoteDataSource();

  Future<void> openGithubUrl();
}

class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  const TemplateRemoteDataSourceImpl();

  @override
  Future<void> openGithubUrl() async {
    try {
      final link = 'https://github.com/MaeAuliya';

      final uriLink = Uri.parse(link);

      if (await canLaunchUrl(uriLink)) {
        await launchUrl(
          uriLink,
          mode: LaunchMode.externalApplication,
        );
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
