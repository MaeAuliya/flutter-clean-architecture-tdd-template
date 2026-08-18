import '../../file_template.dart';
import '../../name_case.dart';

class RemoteDataSourceTemplate extends CoreTemplateGen {
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
import '../../domain/entities/${n.snake}_entity.dart';

abstract class ${n.pascal}RemoteDataSource {
  const ${n.pascal}RemoteDataSource();

  Future<void> update${n.pascal}(${n.pascal}Entity ${n.camel});
}

class ${n.pascal}RemoteDataSourceImpl implements ${n.pascal}RemoteDataSource {
  const ${n.pascal}RemoteDataSourceImpl();

  @override
  Future<void> update${n.pascal}(${n.pascal}Entity ${n.camel}) async {
    // ponytail: replace this typed boundary when remote transport is chosen.
    throw const ServerException.rejected(
      diagnosticMessage: '${n.pascal} remote data source is not configured',
    );
  }
}
''';
}
