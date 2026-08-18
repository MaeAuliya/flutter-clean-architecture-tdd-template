import '../../file_template.dart';
import '../../name_case.dart';

class RepositoryTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) => _template(
    n,
    typedefImport: '../../../../core/utils/typedef.dart',
  );

  @override
  String moduleTpl(NameCase n) => _template(
    n,
    typedefImport: '../../../../utils/typedef.dart',
  );

  String _template(NameCase n, {required String typedefImport}) =>
      '''
import '$typedefImport';
import '../entities/${n.snake}_entity.dart';

abstract class ${n.pascal}Repository {
  const ${n.pascal}Repository();

  ResultFuture<${n.pascal}Entity> get${n.pascal}();

  ResultVoid update${n.pascal}(${n.pascal}Entity ${n.camel}Params);
}
''';
}
