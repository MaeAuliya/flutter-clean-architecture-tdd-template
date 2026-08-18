import 'package:flutter_clean_tdd_template/src/core/services/injection/injectors/template_injector.dart';
import 'package:flutter_clean_tdd_template/src/core/services/logging/app_logger.dart';
import 'package:flutter_clean_tdd_template/src/core/services/url_launcher_gateway/url_launcher_gateway.dart';
import 'package:flutter_clean_tdd_template/src/features/template/domain/repositories/template_repository.dart';
import 'package:flutter_clean_tdd_template/src/features/template/presentation/bloc/template_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockUrlLauncherGateway extends Mock implements UrlLauncherGateway {}

void main() {
  late GetIt locator;

  setUp(() {
    locator = GetIt.asNewInstance();
    locator
      ..registerLazySingleton<AppLogger>(MockAppLogger.new)
      ..registerLazySingleton<UrlLauncherGateway>(MockUrlLauncherGateway.new)
      ..registerLazySingleton(
        () => PackageInfo(
          appName: 'test',
          packageName: 'test',
          version: '1.0.0',
          buildNumber: '1',
        ),
      );
  });

  tearDown(() async => locator.reset());

  test('resolves feature repository and Bloc', () async {
    await const TemplateInjector().inject(locator);

    expect(locator<TemplateRepository>(), isNotNull);
    expect(locator<TemplateBloc>(), isNotNull);
  });
}
