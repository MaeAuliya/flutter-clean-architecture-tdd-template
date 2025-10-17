import 'package:flutter/cupertino.dart';

import '../../domain/entities/template_version.dart';

class TemplateProvider extends ChangeNotifier {
  TemplateVersion? _templateVersion;

  TemplateVersion? get templateVersion => _templateVersion;

  void init() {
    _templateVersion = null;
  }

  void updateTemplateVersion(TemplateVersion version) {
    _templateVersion = version;
    notifyListeners();
  }
}
