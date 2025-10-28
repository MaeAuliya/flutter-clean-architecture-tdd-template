import 'package:dartz/dartz.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/models/template_version_model.dart';
import 'package:flutter_clean_tdd_template/src/features/template/domain/entities/template_version.dart';
import 'package:flutter_clean_tdd_template/src/features/template/domain/repositories/template_repository.dart';
import 'package:flutter_clean_tdd_template/src/features/template/domain/usecases/get_current_template_version.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/template_repository.mock.dart';

class MockGetCurrentTemplateVersion extends Mock
    implements GetCurrentTemplateVersion {}

void main() {
  late TemplateRepository repository;
  late GetCurrentTemplateVersion useCase;

  setUpAll(() {
    repository = MockTemplateRepository();
    useCase = GetCurrentTemplateVersion(repository: repository);
  });

  final eTemplateVersion = const TemplateVersionModel.empty();

  test(
    'Should call the [TemplateRepository.getCurrentTemplateVersion]',
    () async {
      when(
        () => repository.getCurrentTemplateVersion(),
      ).thenAnswer(
        (_) async => Right(eTemplateVersion),
      );

      final result = await useCase();

      expect(result, equals(Right<dynamic, TemplateVersion>(eTemplateVersion)));

      verify(() => repository.getCurrentTemplateVersion()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
