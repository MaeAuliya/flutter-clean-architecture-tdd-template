import '../../file_template.dart';
import '../../name_case.dart';

class BlocCoreTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/${n.snake}_entity.dart';
import '../../domain/usecases/get_${n.snake}.dart';
import '../../domain/usecases/update_${n.snake}.dart';

part '${n.snake}_event.dart';
part '${n.snake}_state.dart';

class ${n.pascal}Bloc extends Bloc<${n.pascal}Event, ${n.pascal}State> {
  final Get${n.pascal} _get${n.pascal};
  final Update${n.pascal} _update${n.pascal};

  ${n.pascal}Bloc({
    required Get${n.pascal} get${n.pascal},
    required Update${n.pascal} update${n.pascal},
  }) : _get${n.pascal} = get${n.pascal},
       _update${n.pascal} = update${n.pascal},
       super(const ${n.pascal}Initial()) {
    on<Get${n.pascal}Event>(_onGet${n.pascal});
    on<Update${n.pascal}Event>(_onUpdate${n.pascal});
  }

  Future<void> _onGet${n.pascal}(
    Get${n.pascal}Event event,
    Emitter<${n.pascal}State> emit,
  ) async {
    emit(const ${n.pascal}Loading());
    final result = await _get${n.pascal}();
    result.fold(
      (failure) => emit(${n.pascal}Error(failure.userMessage)),
      (entity) => emit(Get${n.pascal}Success(entity)),
    );
  }

  Future<void> _onUpdate${n.pascal}(
    Update${n.pascal}Event event,
    Emitter<${n.pascal}State> emit,
  ) async {
    emit(const ${n.pascal}Loading());
    final result = await _update${n.pascal}(event.${n.camel});
    result.fold(
      (failure) => emit(${n.pascal}Error(failure.userMessage)),
      (_) => emit(const Update${n.pascal}Success()),
    );
  }
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
