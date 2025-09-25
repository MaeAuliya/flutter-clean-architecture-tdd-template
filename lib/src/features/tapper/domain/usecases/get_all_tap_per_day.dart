import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/tap_per_day.dart';
import '../repositories/tapper_repository.dart';

class GetAllTapPerDay extends UseCaseWithoutParams<List<TapPerDay>> {
  final TapperRepository _repository;

  const GetAllTapPerDay({required TapperRepository repository})
    : _repository = repository;

  @override
  ResultFuture<List<TapPerDay>> call() => _repository.getAllTapPerDay();
}
