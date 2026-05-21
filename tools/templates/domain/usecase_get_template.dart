import '../../file_template.dart';
import '../../name_case.dart';

class UsecaseGetTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/${n.snake}_entity.dart';
import '../repositories/${n.snake}_repository.dart';


class Get${n.pascal} extends UseCaseWithoutParams<${n.pascal}Entity> {
  final ${n.pascal}Repository _repository;

  const Get${n.pascal}({required ${n.pascal}Repository repository}) : _repository = repository;

  @override
  ResultFuture<${n.pascal}Entity> call() => _repository.get${n.pascal}();
}
''';

  @override
  String? moduleTpl(NameCase n) =>
      '''
import '../../../../usecases/usecase.dart';
import '../../../../utils/typedef.dart';
import '../entities/${n.snake}_entity.dart';
import '../repositories/${n.snake}_repository.dart';


class Get${n.pascal} extends UseCaseWithoutParams<${n.pascal}Entity> {
  final ${n.pascal}Repository _repository;

  const Get${n.pascal}({required ${n.pascal}Repository repository}) : _repository = repository;

  @override
  ResultFuture<${n.pascal}Entity> call() => _repository.get${n.pascal}();
}
''';
}
