import '../../../file_template.dart';
import '../../../name_case.dart';

class ScreenTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared/widgets/core_app_bar.dart';
import '../../../../core/utils/core_utils.dart';
import '../bloc/${n.snake}_bloc.dart';
import '../views/${n.snake}_view.dart';

class ${n.pascal}Screen extends StatefulWidget {
  const ${n.pascal}Screen({super.key});

  static const routeName = '/${n.snake}';

  @override
  State<${n.pascal}Screen> createState() => _${n.pascal}ScreenState();
}

class _${n.pascal}ScreenState extends State<${n.pascal}Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CoreAppBar(
        title: '${n.pascal}',
      ),
      body: BlocListener<${n.pascal}Bloc, ${n.pascal}State>(
        listener: (context, state) {
          switch (state) {
            case ${n.pascal}Error():
              CoreUtils.showSnackBar(
                context: context,
                message: state.errorMessage,
                isError: true,
              );

            case _:
          }
        },
        child: const ${n.pascal}View(),
      ),
    );
  }
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
