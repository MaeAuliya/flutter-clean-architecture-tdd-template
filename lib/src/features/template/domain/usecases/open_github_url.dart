import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/template_repository.dart';

class OpenGithubUrl implements UseCaseWithoutParams<void> {
  final TemplateRepository _repository;

  const OpenGithubUrl({required TemplateRepository repository})
    : _repository = repository;

  @override
  ResultFuture<void> call() => _repository.openGithubUrl();
}
