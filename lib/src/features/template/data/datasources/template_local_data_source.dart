import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/errors/exception.dart';
import '../models/template_version_model.dart';

abstract class TemplateLocalDataSource {
  const TemplateLocalDataSource();

  Future<TemplateVersionModel> getCurrentTemplateVersion();
}

class TemplateLocalDataSourceImpl implements TemplateLocalDataSource {
  final PackageInfo _packageInfo;

  const TemplateLocalDataSourceImpl({
    required PackageInfo packageInfo,
  }) : _packageInfo = packageInfo;

  @override
  Future<TemplateVersionModel> getCurrentTemplateVersion() async {
    try {
      return TemplateVersionModel(
        appName: _packageInfo.appName,
        version: _packageInfo.version,
        buildNumber: _packageInfo.buildNumber,
      );
    } catch (_) {
      throw const LocalException(
        diagnosticMessage: 'Package metadata could not be read',
      );
    }
  }
}
