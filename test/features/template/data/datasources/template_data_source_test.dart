import 'package:flutter_clean_tdd_template/src/core/errors/exception.dart';
import 'package:flutter_clean_tdd_template/src/core/services/url_launcher_gateway/url_launcher_gateway.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/datasources/template_local_data_source.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/datasources/template_remote_data_source.dart';
import 'package:flutter_clean_tdd_template/src/features/template/data/models/template_version_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MockPackageInfo extends Mock implements PackageInfo {}

class MockUrlLauncherGateway extends Mock implements UrlLauncherGateway {}

// If use other packages, e.g, [SharedPreferences] or [DIO] uncomment this one
// class MockSharedPreferences extends Mock implements SharedPreferences {}
//
// class MockDio extends Mock implements Dio {}

void main() {
  late PackageInfo packageInfo;
  late UrlLauncherGateway urlLauncherGateway;
  late TemplateRemoteDataSourceImpl remoteDataSource;
  late TemplateLocalDataSourceImpl localDataSource;
  // late SharedPreferences sharedPreferences;
  // late Dio dio;

  setUp(() {
    packageInfo = MockPackageInfo();
    urlLauncherGateway = MockUrlLauncherGateway();
    remoteDataSource = TemplateRemoteDataSourceImpl(
      urlLauncherGateway: urlLauncherGateway,
    );
    localDataSource = TemplateLocalDataSourceImpl(packageInfo: packageInfo);
  });

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://github.com/MaeAuliya'));

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
    final uri = Uri.parse('https://github.com/MaeAuliya');

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

        expect(
          () => remoteDataSource.openGithubUrl(),
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
          () => remoteDataSource.openGithubUrl(),
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

        expect(
          () => remoteDataSource.openGithubUrl(),
          throwsA(
            isA<ServerException>().having(
              (e) => e.statusCode,
              'statusCode',
              599,
            ),
          ),
        );
      },
    );
  });

  // If you have API calls usecase, e.g. [SignIn], you can uncomment this
  //   group('signIn', () {
  //     final tResponseSuccess = Response(
  //       data: jsonDecode(fixture('login_response.json')) as DataMap,
  //       statusCode: 200,
  //       requestOptions: RequestOptions(path: ''),
  //     );
  //
  //     final tResponseError = Response(
  //       data: {
  //         "success": false,
  //         "message": "Phone and password are required",
  //       },
  //       statusCode: 400,
  //       requestOptions: RequestOptions(path: ''),
  //     );
  //
  //     final tResponseInvalid = Response(
  //       data: {
  //         "success": false,
  //         "message": "Phone and password are incorrect",
  //       },
  //       statusCode: 401,
  //       requestOptions: RequestOptions(path: ''),
  //     );
  //
  //     test('should complete successfully when no [Exception] is thrown',
  //         () async {
  //       when(
  //         () => dio.post(
  //           any(),
  //           data: any(named: 'data'),
  //           options: any(named: 'options'),
  //         ),
  //       ).thenAnswer((_) async => tResponseSuccess);
  //
  //       when(() => sharedPreferences.setString(any(), any()))
  //           .thenAnswer((_) async => true);
  //
  //       when(() => sharedPreferences.setInt(any(), any()))
  //           .thenAnswer((_) async => true);
  //
  //       final request = const LoginRequestModel(
  //         phoneNumber: tPhoneNumber,
  //         password: tPassword,
  //         isSaved: false,
  //       );
  //
  //       final result = await dataSource.signIn(request);
  //
  //       expect(result, equals(tUser));
  //
  //       verify(
  //         () => dio.post(
  //           any(),
  //           data: any(named: 'data'),
  //           options: any(named: 'options'),
  //         ),
  //       ).called(1);
  //       verifyNoMoreInteractions(dio);
  //
  //       verify(() => sharedPreferences.getString(PreferenceKeys.kFcmToken))
  //           .called(1);
  //       verify(() => sharedPreferences.setString(PreferenceKeys.kToken, tToken))
  //           .called(1);
  //       verify(() => sharedPreferences.setInt(PreferenceKeys.kTimestamp, any()))
  //           .called(1);
  //       verify(() => sharedPreferences.setString(
  //           PreferenceKeys.kPinPhoneNumber, request.phoneNumber)).called(1);
  //       verifyNoMoreInteractions(sharedPreferences);
  //     });
  //
  //     test(
  //         'should complete successfully when no [Exception] is thrown and save user authentication data',
  //         () async {
  //       when(
  //         () => dio.post(
  //           any(),
  //           data: any(named: 'data'),
  //           options: any(named: 'options'),
  //         ),
  //       ).thenAnswer((_) async => tResponseSuccess);
  //
  //       when(() => sharedPreferences.setString(any(), any()))
  //           .thenAnswer((_) async => true);
  //
  //       when(() => sharedPreferences.setInt(any(), any()))
  //           .thenAnswer((_) async => true);
  //
  //       final request = const LoginRequestModel(
  //         phoneNumber: tPhoneNumber,
  //         password: tPassword,
  //         isSaved: true,
  //       );
  //
  //       final result = await dataSource.signIn(request);
  //
  //       expect(result, equals(tUser));
  //
  //       verify(
  //         () => dio.post(
  //           any(),
  //           data: any(named: 'data'),
  //           options: any(named: 'options'),
  //         ),
  //       ).called(1);
  //       verifyNoMoreInteractions(dio);
  //
  //       verify(() => sharedPreferences.getString(PreferenceKeys.kFcmToken))
  //           .called(1);
  //       verify(() => sharedPreferences.setString(PreferenceKeys.kToken, tToken))
  //           .called(1);
  //       verify(() => sharedPreferences.setInt(PreferenceKeys.kTimestamp, any()))
  //           .called(1);
  //       verify(() => sharedPreferences.setString(
  //           PreferenceKeys.kPhoneNumber, tPhoneNumber)).called(1);
  //       verify(() =>
  //               sharedPreferences.setString(PreferenceKeys.kPassword, tPassword))
  //           .called(1);
  //       verify(() =>
  //               sharedPreferences.setInt(PreferenceKeys.kRequestTimestamp, any()))
  //           .called(1);
  //       verify(() => sharedPreferences.setString(
  //           PreferenceKeys.kPinPhoneNumber, request.phoneNumber)).called(1);
  //       verifyNoMoreInteractions(sharedPreferences);
  //     });
  //
  //     test('should return null with error code 401 because if wrong credentials',
  //         () async {
  //       when(
  //         () => dio.post(
  //           any(),
  //           data: any(named: 'data'),
  //           options: any(named: 'options'),
  //         ),
  //       ).thenAnswer((_) async => tResponseInvalid);
  //
  //       final request = const LoginRequestModel(
  //         phoneNumber: tPhoneNumber,
  //         password: tPassword,
  //         isSaved: false,
  //       );
  //
  //       final result = await dataSource.signIn(request);
  //
  //       expect(result, isNull);
  //
  //       verify(
  //         () => dio.post(
  //           any(),
  //           data: any(named: 'data'),
  //           options: any(named: 'options'),
  //         ),
  //       ).called(1);
  //       verifyNoMoreInteractions(dio);
  //
  //       verifyNever(
  //           () => sharedPreferences.setString(PreferenceKeys.kToken, tToken));
  //       verifyNever(
  //           () => sharedPreferences.setInt(PreferenceKeys.kTimestamp, any()));
  //     });
  //
  //     test(
  //       'should throw [ServerException] when error signing in',
  //       () async {
  //         when(
  //           () => dio.post(
  //             any(),
  //             data: any(named: 'data'),
  //             options: any(named: 'options'),
  //           ),
  //         ).thenAnswer(
  //           (_) async => tResponseError,
  //         );
  //
  //         final request = const LoginRequestModel(
  //           phoneNumber: tPhoneNumber,
  //           password: tPassword,
  //           isSaved: false,
  //         );
  //
  //         final call = dataSource.signIn(request);
  //         expect(
  //           () => call,
  //           throwsA(isA<ServerException>()),
  //         );
  //
  //         verify(
  //           () => dio.post(
  //             any(),
  //             data: any(named: 'data'),
  //             options: any(named: 'options'),
  //           ),
  //         ).called(1);
  //         verifyNoMoreInteractions(dio);
  //       },
  //     );
  //   });
}
