import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/tapper_repository.dart';

class LongPress extends UseCaseWithParams<void, int> {
  final TapperRepository _repository;

  const LongPress({required TapperRepository repository})
    : _repository = repository;

  @override
  ResultFuture<void> call(int taps) => _repository.longPress(taps);
}
