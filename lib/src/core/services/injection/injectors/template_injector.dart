import 'package:get_it/get_it.dart';

import '../../../../features/template/data/datasources/template_local_data_source.dart';
import '../../../../features/template/data/datasources/template_remote_data_source.dart';
import '../../../../features/template/data/repositories/template_repository_impl.dart';
import '../../../../features/template/domain/repositories/template_repository.dart';
import '../../../../features/template/domain/usecases/get_current_template_version.dart';
import '../../../../features/template/domain/usecases/open_github_url.dart';
import '../../../../features/template/presentation/bloc/template_bloc.dart';
import '../injection_container.dart';

class TemplateInjector implements Injector {
  const TemplateInjector();

  @override
  Future<void> inject(GetIt sl) async {
    sl
      // Bloc
      ..registerFactory(
        () => TemplateBloc(
          getCurrentTemplateVersion: sl(),
          openGithubUrl: sl(),
        ),
      )
      // Usecases
      ..registerLazySingleton(() => GetCurrentTemplateVersion(repository: sl()))
      ..registerLazySingleton(() => OpenGithubUrl(repository: sl()))
      // Repository
      ..registerLazySingleton<TemplateRepository>(
        () => TemplateRepositoryImpl(
          localDataSource: sl(),
          remoteDataSource: sl(),
        ),
      )
      // Data Sources
      ..registerLazySingleton<TemplateLocalDataSource>(
        () => TemplateLocalDataSourceImpl(
          packageInfo: sl(),
        ),
      )
      ..registerLazySingleton<TemplateRemoteDataSource>(
        () => TemplateRemoteDataSourceImpl(
          urlLauncherGateway: sl(),
        ),
      );
  }
}
