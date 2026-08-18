import '../../file_template.dart';
import '../../name_case.dart';

class LocalDataSourceTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) => _template(
    n,
    exceptionImport: '../../../../core/errors/exception.dart',
  );

  @override
  String moduleTpl(NameCase n) => _template(
    n,
    exceptionImport: '../../../../errors/exception.dart',
  );

  String _template(NameCase n, {required String exceptionImport}) =>
      '''
import '$exceptionImport';
import '../models/${n.snake}_model.dart';

abstract class ${n.pascal}LocalDataSource {
  const ${n.pascal}LocalDataSource();

  Future<${n.pascal}Model> get${n.pascal}();
}

class ${n.pascal}LocalDataSourceImpl implements ${n.pascal}LocalDataSource {
  const ${n.pascal}LocalDataSourceImpl();

  @override
  Future<${n.pascal}Model> get${n.pascal}() async {
    // ponytail: replace this typed boundary when local persistence is chosen.
    throw const LocalException(
      diagnosticMessage: '${n.pascal} local data source is not configured',
    );
  }
}
''';
}
