import '../../file_template.dart';
import '../../name_case.dart';

class ProviderTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import 'package:flutter/foundation.dart';

import '../../domain/entities/${n.snake}_entity.dart';

class ${n.pascal}Provider extends ChangeNotifier {
  ${n.pascal}Entity? _current${n.pascal};

  ${n.pascal}Entity? get current${n.pascal} => _current${n.pascal};

  void updateCurrent${n.pascal}(${n.pascal}Entity ${n.camel}) {
    _current${n.pascal} = ${n.camel};
    notifyListeners();
  }

  void clearCurrent${n.pascal}() {
    _current${n.pascal} = null;
    notifyListeners();
  }
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
