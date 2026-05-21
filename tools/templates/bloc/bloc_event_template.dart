import '../../file_template.dart';
import '../../name_case.dart';

class BlocEventTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
part of '${n.snake}_bloc.dart';

abstract class ${n.pascal}Event extends Equatable {
  const ${n.pascal}Event();

  @override
  List<Object?> get props => [];
}


final class Get${n.pascal}Event extends ${n.pascal}Event {
  const Get${n.pascal}Event();
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
