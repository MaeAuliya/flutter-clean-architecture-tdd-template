import 'package:flutter_clean_tdd_template/src/core/errors/exception.dart';
import 'package:flutter_clean_tdd_template/src/core/services/url_launcher_gateway/url_launcher_gateway.dart';
import 'package:flutter_clean_tdd_template/src/core/utils/constants.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/datasources/template_local_data_source.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/datasources/template_remote_data_source.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/models/template_version_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MockPackageInfo extends Mock implements PackageInfo {}

class MockUrlLauncherGateway extends Mock implements UrlLauncherGateway {}

void main() {
  late PackageInfo packageInfo;
  late UrlLauncherGateway urlLauncherGateway;
  late TemplateRemoteDataSourceImpl remoteDataSource;
  late TemplateLocalDataSourceImpl localDataSource;

  setUp(() {
    packageInfo = MockPackageInfo();
    urlLauncherGateway = MockUrlLauncherGateway();
    remoteDataSource = TemplateRemoteDataSourceImpl(
      urlLauncherGateway: urlLauncherGateway,
    );
    localDataSource = TemplateLocalDataSourceImpl(packageInfo: packageInfo);
  });

  setUpAll(() {
    registerFallbackValue(Uri.parse(Constants.githubUrl));

    registerFallbackValue(LaunchMode.externalApplication);
  });

  group('[GetCurrentTemplateVersion] usecase', () {
    test(
      'Should complete successfully when no [Exception] is thrown',
      () async {
        when(
          () => packageInfo.appName,
        ).thenReturn('Flutter Clean Architecture TDD Template');
        when(() => packageInfo.version).thenReturn('1.0.0');
        when(() => packageInfo.buildNumber).thenReturn('1');

        final eResult = TemplateVersionModel(
          appName: packageInfo.appName,
          version: packageInfo.version,
          buildNumber: packageInfo.buildNumber,
        );

        final tResult = await localDataSource.getCurrentTemplateVersion();

        expect(tResult, equals(eResult));
      },
    );
  });

  group('[OpenGithubUrl] usecase', () {
    final uri = Uri.parse(Constants.githubUrl);

    test(
      'Should complete successfully when launch calls with ExternalApplication Mode',
      () async {
        // arrange
        when(
          () => urlLauncherGateway.canLaunch(uri),
        ).thenAnswer((_) async => true);
        when(
          () => urlLauncherGateway.launch(
            uri,
            mode: LaunchMode.externalApplication,
          ),
        ).thenAnswer((_) async => true);

        // act
        await remoteDataSource.openGithubUrl();

        // assert
        verify(() => urlLauncherGateway.canLaunch(uri)).called(1);
        verify(
          () => urlLauncherGateway.launch(
            uri,
            mode: LaunchMode.externalApplication,
          ),
        ).called(1);
        verifyNoMoreInteractions(urlLauncherGateway);
      },
    );

    test(
      'Should throw [ServerException] when canLaunch return false',
      () async {
        when(
          () => urlLauncherGateway.canLaunch(uri),
        ).thenAnswer((_) async => false);

        await expectLater(
          remoteDataSource.openGithubUrl(),
          throwsA(isA<ServerException>()),
        );

        verify(() => urlLauncherGateway.canLaunch(uri)).called(1);
        verifyNever(
          () => urlLauncherGateway.launch(any(), mode: any(named: 'mode')),
        );
      },
    );

    test(
      'Should throw [ServerException] when launch return false',
      () async {
        when(
          () => urlLauncherGateway.canLaunch(uri),
        ).thenAnswer((_) async => true);
        when(
          () => urlLauncherGateway.launch(
            uri,
            mode: LaunchMode.externalApplication,
          ),
        ).thenAnswer((_) async => false);

        await expectLater(
          remoteDataSource.openGithubUrl(),
          throwsA(isA<ServerException>()),
        );

        verify(() => urlLauncherGateway.canLaunch(uri)).called(1);
        verify(
          () => urlLauncherGateway.launch(
            uri,
            mode: LaunchMode.externalApplication,
          ),
        ).called(1);
      },
    );

    test(
      'Should throw [ServerException] when this usecase unsuccessfully',
      () async {
        when(
          () => urlLauncherGateway.canLaunch(uri),
        ).thenAnswer((_) async => true);
        when(
          () => urlLauncherGateway.launch(
            uri,
            mode: LaunchMode.externalApplication,
          ),
        ).thenThrow(Exception('platform error'));

        await expectLater(
          remoteDataSource.openGithubUrl(),
          throwsA(
            isA<ServerException>().having(
              (e) => e.kind,
              'kind',
              ServerExceptionKind.rejected,
            ),
          ),
        );
      },
    );
  });
}
