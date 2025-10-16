import 'package:flutter/cupertino.dart';

import '../../data/models/template_version_model.dart';
import '../../domain/entities/template_version.dart';

class TemplateProvider extends ChangeNotifier {
  TemplateVersionModel? _templateVersion;

  TemplateVersionModel? get templateVersion => _templateVersion;

  void init() {
    _templateVersion = null;
  }

  void updateTemplateVersion(TemplateVersion version) {
    _templateVersion = TemplateVersionModel.fromEntity(version);
    notifyListeners();
  }
}
