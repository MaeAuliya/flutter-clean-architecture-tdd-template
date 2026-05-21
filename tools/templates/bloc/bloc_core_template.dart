import '../../file_template.dart';
import '../../name_case.dart';

class BlocCoreTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/${n.snake}_entity.dart';

part '${n.snake}_event.dart';
part '${n.snake}_state.dart';

class ${n.pascal}Bloc extends Bloc<${n.pascal}Event, ${n.pascal}State> {
  ${n.pascal}Bloc() : super(const ${n.pascal}Initial()) {
    on<${n.pascal}Event>((_, emit) {
      emit(const ${n.pascal}Reset());
    });
  }
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
