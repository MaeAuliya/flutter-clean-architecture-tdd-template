import 'package:flutter_clean_tdd_template/src/features/template/data/models/template_version_model.dart';
import 'package:flutter_clean_tdd_template/src/features/template/domain/entities/template_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTemplateVersionModel = TemplateVersionModel.empty();

  test(
    'Should be a class of [TemplateVersion] entity',
    () => expect(tTemplateVersionModel, isA<TemplateVersion>()),
  );

  group('[TemplateVersionModel] factory function', () {
    test(
      'Should return a valid [TemplateVersionModel] with default / empty function]',
      () {
        const eTemplateVersionModel = TemplateVersionModel(
          appName: 'template',
          version: '',
          buildNumber: '',
        );
        expect(tTemplateVersionModel, equals(eTemplateVersionModel));
      },
    );

    test(
      'Should return a valid [TemplateVersionModel] from [TemplateVersion] entity',
      () {
        const eTemplateVersion = TemplateVersion(
          appName: 'template',
          version: '',
          buildNumber: '',
        );
        const call = TemplateVersionModel.fromEntity;

        expect(call(eTemplateVersion), equals(tTemplateVersionModel));
      },
    );
  });
}
