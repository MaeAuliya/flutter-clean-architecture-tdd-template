import '../../file_template.dart';
import '../../name_case.dart';

class EntityTemplate implements CoreTemplateGen {
  @override
  String featureTpl(NameCase n) => _template(n);

  @override
  String moduleTpl(NameCase n) => _template(n);

  String _template(NameCase n) =>
      '''
import 'package:equatable/equatable.dart';

class ${n.pascal}Entity extends Equatable {
  const ${n.pascal}Entity();

  @override
  List<Object?> get props => [];
}
''';
}
