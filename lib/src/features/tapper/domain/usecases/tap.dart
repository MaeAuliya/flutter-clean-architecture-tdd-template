import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/tapper_repository.dart';

class Tap implements UseCaseWithParams<void, int> {
  final TapperRepository _repository;

  const Tap({required TapperRepository repository}) : _repository = repository;

  @override
  ResultFuture<void> call(int steps) => _repository.tap(steps);
}
