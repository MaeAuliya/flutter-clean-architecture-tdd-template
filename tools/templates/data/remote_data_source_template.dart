import '../../file_template.dart';
import '../../name_case.dart';

class RemoteDataSourceTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
abstract class ${n.pascal}RemoteDataSource {
  const ${n.pascal}RemoteDataSource();
}


class ${n.pascal}RemoteDataSourceImpl implements ${n.pascal}RemoteDataSource {
  const ${n.pascal}RemoteDataSourceImpl();
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
