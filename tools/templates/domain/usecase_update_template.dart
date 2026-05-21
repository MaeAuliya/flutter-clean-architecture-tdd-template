import '../../file_template.dart';
import '../../name_case.dart';

class UsecaseUpdateTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/${n.snake}_entity.dart';
import '../repositories/${n.snake}_repository.dart';


class Update${n.pascal} extends UseCaseWithParams<void, ${n.pascal}Entity> {
  final ${n.pascal}Repository _repository;

  const Update${n.pascal}({required ${n.pascal}Repository repository}) : _repository = repository;


  @override
  ResultFuture<void> call(${n.pascal}Entity ${n.camel}Params) => _repository.update${n.pascal}(${n.camel}Params);
}
''';

  @override
  String? moduleTpl(NameCase n) =>
      '''
import '../../../../usecases/usecase.dart';
import '../../../../utils/typedef.dart';
import '../entities/${n.snake}_entity.dart';
import '../repositories/${n.snake}_repository.dart';


class Update${n.pascal} extends UseCaseWithParams<void, ${n.pascal}Entity> {
  final ${n.pascal}Repository _repository;

  const Update${n.pascal}({required ${n.pascal}Repository repository}) : _repository = repository;


  @override
  ResultFuture<void> call(${n.pascal}Entity ${n.camel}Params) => _repository.update${n.pascal}(${n.camel}Params);
}
''';
}
