import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/tap_per_day.dart';
import '../repositories/tapper_repository.dart';

class GetTodayTapPerDay extends UseCaseWithoutParams<TapPerDay?> {
  final TapperRepository _repository;

  const GetTodayTapPerDay({required TapperRepository repository})
    : _repository = repository;

  @override
  ResultFuture<TapPerDay?> call() => _repository.getTodayTapPerDay();
}
