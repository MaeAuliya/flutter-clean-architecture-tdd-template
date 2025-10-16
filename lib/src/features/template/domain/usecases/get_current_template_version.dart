import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/template_version.dart';
import '../repositories/template_repository.dart';

class GetCurrentTemplateVersion
    implements UseCaseWithoutParams<TemplateVersion> {
  final TemplateRepository _repository;

  const GetCurrentTemplateVersion({required TemplateRepository repository})
    : _repository = repository;

  @override
  ResultFuture<TemplateVersion> call() =>
      _repository.getCurrentTemplateVersion();
}
