import '../../file_template.dart';
import '../../name_case.dart';

class LocalDataSourceTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
abstract class ${n.pascal}LocalDataSource {
  const ${n.pascal}LocalDataSource();
}


class ${n.pascal}LocalDataSourceImpl implements ${n.pascal}LocalDataSource {
  const ${n.pascal}LocalDataSourceImpl();
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
