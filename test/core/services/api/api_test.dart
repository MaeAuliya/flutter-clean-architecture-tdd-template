import 'package:flutter_clean_tdd_template/src/core/services/api/api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reports every missing required key', () {
    const api = API(baseUrl: '');

    expect(api.missingKeys(), ['BASE_URL']);
  });

  test('fails before startup when required configuration is missing', () {
    const api = API(baseUrl: '');

    expect(
      api.validate,
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('BASE_URL'),
        ),
      ),
    );
  });

  test('rejects non-HTTPS base URLs', () {
    const api = API(baseUrl: 'http://api.example.invalid');

    expect(
      api.validate,
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('must be HTTPS'),
        ),
      ),
    );
  });

  test('accepts complete required configuration', () {
    const api = API(baseUrl: 'https://api.example.invalid');

    expect(api.validate, returnsNormally);
  });
}
