import '../../../file_template.dart';
import '../../../name_case.dart';

class ContextExtensionTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/${n.snake}_bloc.dart';
import '../providers/${n.snake}_provider.dart';

extension ${n.pascal}ContextExtension on BuildContext {
  ${n.pascal}Bloc get ${n.camel}Bloc => read<${n.pascal}Bloc>();

  ${n.pascal}Provider get ${n.camel}Provider => read<${n.pascal}Provider>();
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
