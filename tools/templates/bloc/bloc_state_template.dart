import '../../file_template.dart';
import '../../name_case.dart';

class BlocStateTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
part of '${n.snake}_bloc.dart';

abstract class ${n.pascal}State extends Equatable {
  const ${n.pascal}State();

  @override
  List<Object?> get props => [];
}


final class ${n.pascal}Initial extends ${n.pascal}State {
  const ${n.pascal}Initial();
}


final class ${n.pascal}Reset extends ${n.pascal}State {
  const ${n.pascal}Reset();
}


final class Get${n.pascal}Success extends ${n.pascal}State {
  final ${n.pascal}Entity ${n.camel}Entity;

  const Get${n.pascal}Success(this.${n.camel}Entity);

  @override
  List<Object?> get props => [${n.camel}Entity];
}

final class ${n.pascal}Loading extends ${n.pascal}State {
  const ${n.pascal}Loading();
}

final class ${n.pascal}Error extends ${n.pascal}State {
  final String errorMessage;

  const ${n.pascal}Error(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
