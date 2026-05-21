import 'name_case.dart';

abstract class CoreTemplateGen {
  const CoreTemplateGen();

  String featureTpl(NameCase n);

  String? moduleTpl(NameCase n);
}
