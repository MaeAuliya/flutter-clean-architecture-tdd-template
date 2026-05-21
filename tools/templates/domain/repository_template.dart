import '../../file_template.dart';
import '../../name_case.dart';

class RepositoryTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import '../../../../core/utils/typedef.dart';
import '../entities/${n.snake}_entity.dart';     
 
abstract class ${n.pascal}Repository {
  const ${n.pascal}Repository();

  ResultFuture<${n.pascal}Entity> get${n.pascal}();

  ResultVoid update${n.pascal}(${n.pascal}Entity ${n.camel}Params);
}
''';

  @override
  String? moduleTpl(NameCase n) =>
      '''
import '../../../../utils/typedef.dart';
import '../entities/${n.snake}_entity.dart';     
 
abstract class ${n.pascal}Repository {
  const ${n.pascal}Repository();

  ResultFuture<${n.pascal}Entity> get${n.pascal}();

  ResultVoid update${n.pascal}(${n.pascal}Entity ${n.camel}Params);
}
''';
}
