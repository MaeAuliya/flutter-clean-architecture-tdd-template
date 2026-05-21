import '../../file_template.dart';
import '../../name_case.dart';

class ModelTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import '../../domain/entities/${n.snake}_entity.dart';


class ${n.pascal}Model extends ${n.pascal}Entity {
  const ${n.pascal}Model();
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
