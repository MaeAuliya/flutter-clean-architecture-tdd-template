import 'package:dartz/dartz.dart';
import 'package:flutter_clean_tdd_template/src/features/template/domain/repositories/template_repository.dart';
import 'package:flutter_clean_tdd_template/src/features/template/domain/usecases/open_github_url.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/template_repository.mock.dart';

class MockOpenGithubUrl extends Mock implements OpenGithubUrl {}

void main() {
  late TemplateRepository repository;
  late OpenGithubUrl useCase;

  setUpAll(() {
    repository = MockTemplateRepository();
    useCase = OpenGithubUrl(repository: repository);
  });

  test(
    'Should call the [AuthenticationRepository.openGithubUrl]',
    () async {
      when(
        () => repository.openGithubUrl(),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await useCase();

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => repository.openGithubUrl()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
