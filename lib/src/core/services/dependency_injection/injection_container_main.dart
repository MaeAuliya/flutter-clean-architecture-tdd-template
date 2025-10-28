part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final preference = await SharedPreferences.getInstance();
  final dio = Dio();
  final api = const API();
  final packageInfo = await PackageInfo.fromPlatform();

  // For Cores
  await _initCore(
    preference: preference,
    dio: dio,
    api: api,
    packageInfo: packageInfo,
  );
  // For Features
  await Future.wait([
    // // Services
    // _initExampleService(),

    // // Features
    _initTemplate(),
    // _initExample(),
  ]);
}

Future<void> _initCore({
  required SharedPreferences preference,
  required Dio dio,
  required API api,
  required PackageInfo packageInfo,
}) async {
  sl
    ..registerLazySingleton(() => preference)
    ..registerLazySingleton(() => dio)
    ..registerLazySingleton(() => api)
    ..registerLazySingleton(() => packageInfo)
    ..registerLazySingleton<UrlLauncherGateway>(() => UrlLauncherGatewayImpl());
}

// Future<void> _initExampleService() async {
//   sl
//     // Usecases
//     ..registerLazySingleton(() => GetExampleService(repository: sl()))
//     // Repository
//     ..registerLazySingleton<ServiceRepository>(
//       () => ServiceRepositoryImpl(
//         remoteDataSource: sl(),
//       ),
//     )
//     // Data Sources
//     ..registerLazySingleton<ServiceRemoteDataSource>(
//       () => ServiceRemoteDataSourceImpl(
//         dio: sl(),
//         api: sl(),
//       ),
//     );
// }

Future<void> _initTemplate() async {
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
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    )
    // Data Sources
    ..registerLazySingleton<TemplateLocalDataSource>(
      () => TemplateLocalDataSourceImpl(packageInfo: sl()),
    )
    ..registerLazySingleton<TemplateRemoteDataSource>(
      () => TemplateRemoteDataSourceImpl(urlLauncherGateway: sl()),
    );
}

// Future<void> _initExampleFeature() async {
//   sl
//     // Bloc
//     ..registerFactory(
//       () => ExampleBloc(
//         getExample: sl(),
//       ),
//     )
//     // Usecases
//     ..registerLazySingleton(() => GetExample(repository: sl()))
//     // Repository
//     ..registerLazySingleton<ExampleRepository>(
//       () => ExampleRepositoryImpl(
//         remoteDataSource: sl(),
//         localDataSource: sl(),
//       ),
//     )
//     // Data Sources
//     ..registerLazySingleton<ExampleLocalDataSource>(
//       () => const ExampleLocalDataSourceImpl(),
//     )
//     ..registerLazySingleton<ExampleRemoteDataSource>(
//       () => const ExampleRemoteDataSourceImpl(),
//     );
// }
