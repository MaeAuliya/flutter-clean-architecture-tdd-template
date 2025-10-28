import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_tdd_template/src/core/errors/failure.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/models/template_version_model.dart';
import 'package:flutter_clean_tdd_template/src/features/template/domain/usecases/get_current_template_version.dart';
import 'package:flutter_clean_tdd_template/src/features/template/domain/usecases/open_github_url.dart';
import 'package:flutter_clean_tdd_template/src/features/template/presentation/bloc/template_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/usecases/get_current_template_version_test.dart';
import '../../domain/usecases/open_github_url_test.dart';

void main() {
  late GetCurrentTemplateVersion getCurrentTemplateVersion;
  late OpenGithubUrl openGithubUrl;

  late TemplateBloc templateBloc;

  const tServerFailure = ServerFailure(
    message: 'message',
    statusCode: 505,
  );

  const tLocalFailure = LocalFailure(
    message: 'message',
    statusCode: 505,
  );

  setUp(() {
    getCurrentTemplateVersion = MockGetCurrentTemplateVersion();
    openGithubUrl = MockOpenGithubUrl();
    templateBloc = TemplateBloc(
      getCurrentTemplateVersion: getCurrentTemplateVersion,
      openGithubUrl: openGithubUrl,
    );
  });

  tearDown(() => templateBloc.close());

  test('InitialState must be [TemplateInit]', () {
    expect(templateBloc.state, const TemplateInit());
  });

  group('[GetCurrentTemplateVersion] event handler', () {
    const tTemplateVersion = TemplateVersionModel.empty();

    blocTest<TemplateBloc, TemplateState>(
      'Should emit [GetCurrentTemplateVersionSuccess] when [GetCurrentTemplateVersionEvent] is added',
      build: () {
        when(() => getCurrentTemplateVersion()).thenAnswer(
          (_) async => const Right(tTemplateVersion),
        );
        return templateBloc;
      },
      seed: () => const TemplateReset(),
      act: (bloc) {
        bloc.add(const GetCurrentTemplateVersionEvent());
      },
      expect: () => [
        const GetCurrentTemplateVersionLoading(),
        const GetCurrentTemplateVersionSuccess(tTemplateVersion),
      ],
    );

    blocTest<TemplateBloc, TemplateState>(
      'Should emit [GetCurrentTemplateVersionError] when [GetCurrentTemplateVersionEvent] is added',
      build: () {
        when(() => getCurrentTemplateVersion()).thenAnswer(
          (_) async => const Left(tLocalFailure),
        );
        return templateBloc;
      },
      seed: () => const TemplateReset(),
      act: (bloc) {
        bloc.add(const GetCurrentTemplateVersionEvent());
      },
      expect: () => [
        const GetCurrentTemplateVersionLoading(),
        GetCurrentTemplateVersionError(tLocalFailure.message),
      ],
    );
  });

  group('[OpenGithubUrl] event handler', () {
    blocTest<TemplateBloc, TemplateState>(
      'Should emit [OpenGithubUrlSuccess] when [OpenGithubUrlEvent] is added',
      build: () {
        when(() => openGithubUrl()).thenAnswer(
          (_) async => const Right(null),
        );
        return templateBloc;
      },
      seed: () => const TemplateReset(),
      act: (bloc) {
        bloc.add(const OpenGithubUrlEvent());
      },
      expect: () => [
        const OpenGithubUrlSuccess(),
      ],
    );

    blocTest<TemplateBloc, TemplateState>(
      'Should emit [OpenGithubUrlError] when [OpenGithubUrlEvent] is added',
      build: () {
        when(() => openGithubUrl()).thenAnswer(
          (_) async => const Left(tServerFailure),
        );
        return templateBloc;
      },
      seed: () => const TemplateReset(),
      act: (bloc) {
        bloc.add(const OpenGithubUrlEvent());
      },
      expect: () => [
        OpenGithubUrlError(tServerFailure.message),
      ],
    );
  });

  group('[SplashScreenMove] event handler', () {
    blocTest<TemplateBloc, TemplateState>(
      'Should emit [SplashScreenDone] when [SplashScreenMoveEvent] is added',
      build: () {
        return templateBloc;
      },
      act: (bloc) {
        bloc.add(const SplashScreenMoveEvent());
      },
      seed: () => const TemplateReset(),
      wait: const Duration(milliseconds: 2100),
      expect: () async => [
        const SplashScreenDone(),
      ],
    );
  });
}
