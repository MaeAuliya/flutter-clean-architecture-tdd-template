import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/utils/constants.dart';

abstract class TapperRemoteDataSource {
  const TapperRemoteDataSource();

  Future<void> goToRepository();
}

class TapperRemoteDataSourceImpl implements TapperRemoteDataSource {
  const TapperRemoteDataSourceImpl();

  @override
  Future<void> goToRepository() async {
    try {
      final uriLink = Uri.parse(Constants.repositoryUrl);

      if (await canLaunchUrl(uriLink)) {
        await launchUrl(uriLink, mode: LaunchMode.externalApplication);
      } else {
        throw const ServerException(
          message: 'Couldn`t open this link.',
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
