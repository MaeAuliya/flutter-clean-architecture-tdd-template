import 'package:flutter_clean_tdd_template/src/features/template/data/models/template_version_model.dart';
import 'package:flutter_clean_tdd_template/src/features/template/domain/entities/template_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTemplateVersionModel = TemplateVersionModel.empty();

  // if you have API Calls, just copy it sample response to fixture folder
  // then decode it json
  // final exampleResponse = jsonDecode(fixture('example_response.json')) as DataMap;
  //   final tMap = response['data'];

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

    // If you have API calls, using this pipeline also
    // test('should return a valid [UserModel] from the Map', () {
    //       final result = UserModel.fromMap(tMap);
    //
    //       expect(result, equals(tUserModel));
    //     });
    //
    //     test('should throw an Error when the map is invalid ', () {
    //       final map = DataMap.from(tMap)..remove('is_created_password');
    //
    //       const call = UserModel.fromMap;
    //
    //       expect(() => call(map), throwsA(isA<Error>()));
    //     });
  });
}
