import '../../../../core/utils/typedef.dart';
import '../entities/template_version.dart';

abstract class TemplateRepository {
  const TemplateRepository();

  ResultVoid openGithubUrl();

  ResultFuture<TemplateVersion> getCurrentTemplateVersion();
}
