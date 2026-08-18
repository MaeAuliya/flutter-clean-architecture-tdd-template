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

final class Update${n.pascal}Event extends ${n.pascal}Event {
  final ${n.pascal}Entity ${n.camel};

  const Update${n.pascal}Event(this.${n.camel});

  @override
  List<Object?> get props => [${n.camel}];
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
