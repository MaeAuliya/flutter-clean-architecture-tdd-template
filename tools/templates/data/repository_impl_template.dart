import '../../file_template.dart';
import '../../name_case.dart';

class RepositoryImplTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/${n.snake}_entity.dart';
import '../../domain/repositories/${n.snake}_repository.dart';


class ${n.pascal}RepositoryImpl implements ${n.pascal}Repository {
  const ${n.pascal}RepositoryImpl();

  @override
  ResultFuture<${n.pascal}Entity> get${n.pascal}() {
    // TODO: implement get${n.pascal}
    throw UnimplementedError();
  }

  @override
  ResultVoid update${n.pascal}(${n.pascal}Entity ${n.camel}Params) {
    // TODO: implement update${n.pascal}
    throw UnimplementedError();
  }
}
''';

  @override
  String? moduleTpl(NameCase n) =>
      '''
import '../../../../utils/typedef.dart';
import '../../domain/entities/${n.snake}_entity.dart';
import '../../domain/repositories/${n.snake}_repository.dart';


class ${n.pascal}RepositoryImpl implements ${n.pascal}Repository {
  const ${n.pascal}RepositoryImpl();

  @override
  ResultFuture<${n.pascal}Entity> get${n.pascal}() {
    // TODO: implement get${n.pascal}
    throw UnimplementedError();
  }

  @override
  ResultVoid update${n.pascal}(${n.pascal}Entity ${n.camel}Params) {
    // TODO: implement update${n.pascal}
    throw UnimplementedError();
  }
}
''';
}
