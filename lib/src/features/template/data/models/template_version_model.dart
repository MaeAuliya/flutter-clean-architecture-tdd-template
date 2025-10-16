import '../../domain/entities/template_version.dart';

class TemplateVersionModel extends TemplateVersion {
  const TemplateVersionModel({
    required super.appName,
    required super.version,
    required super.buildNumber,
  });

  const TemplateVersionModel.empty()
    : super(
        appName: 'template',
        version: '',
        buildNumber: '',
      );

  TemplateVersionModel.fromEntity(TemplateVersion entity)
    : super(
        appName: entity.appName,
        version: entity.version,
        buildNumber: entity.buildNumber,
      );
}
