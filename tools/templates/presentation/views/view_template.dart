import '../../../file_template.dart';
import '../../../name_case.dart';

class ViewTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import 'package:flutter/material.dart';

class ${n.pascal}View extends StatelessWidget {
  const ${n.pascal}View({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
