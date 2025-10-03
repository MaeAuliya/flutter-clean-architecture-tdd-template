import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/tapper_repository.dart';

class GoToRepository implements UseCaseWithoutParams<void> {
  final TapperRepository _repository;

  const GoToRepository({required TapperRepository repository})
    : _repository = repository;

  @override
  ResultFuture<void> call() => _repository.goToRepository();
}
