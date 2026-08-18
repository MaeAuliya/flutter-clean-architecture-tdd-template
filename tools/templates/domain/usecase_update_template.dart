import '../../file_template.dart';
import '../../name_case.dart';

class UsecaseUpdateTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) => _template(
    n,
    usecaseImport: '../../../../core/usecases/usecase.dart',
    typedefImport: '../../../../core/utils/typedef.dart',
  );

  @override
  String moduleTpl(NameCase n) => _template(
    n,
    usecaseImport: '../../../../usecases/usecase.dart',
    typedefImport: '../../../../utils/typedef.dart',
  );

  String _template(
    NameCase n, {
    required String usecaseImport,
    required String typedefImport,
  }) =>
      '''
import '$usecaseImport';
import '$typedefImport';
import '../entities/${n.snake}_entity.dart';
import '../repositories/${n.snake}_repository.dart';

class Update${n.pascal} extends UseCaseWithParams<void, ${n.pascal}Entity> {
  final ${n.pascal}Repository _repository;

  const Update${n.pascal}({required ${n.pascal}Repository repository})
    : _repository = repository;

  @override
  ResultFuture<void> call(${n.pascal}Entity ${n.camel}Params) =>
      _repository.update${n.pascal}(${n.camel}Params);
}
''';
}
