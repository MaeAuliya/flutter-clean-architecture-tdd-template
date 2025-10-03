part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final preference = await SharedPreferences.getInstance();
  final dio = Dio();
  final api = const API();
  final packageInfo = await PackageInfo.fromPlatform();
  final database = await LocalDatabase.initLocalDatabase();

  // For Cores
  await _initCore(
    preference: preference,
    dio: dio,
    api: api,
    packageInfo: packageInfo,
    database: database,
  );
  // For Features
  await Future.wait([
    _initTapper(),
    // Feature A
    // Feature B
    // Feature C
  ]);
}

Future<void> _initCore({
  required SharedPreferences preference,
  required Dio dio,
  required API api,
  required PackageInfo packageInfo,
  required Database database,
}) async {
  sl
    ..registerLazySingleton(() => preference)
    ..registerLazySingleton(() => dio)
    ..registerLazySingleton(() => api)
    ..registerLazySingleton(() => packageInfo)
    ..registerLazySingleton(() => database);
}

Future<void> _initTapper() async {
  sl
    // Bloc
    ..registerFactory(
      () => TapperBloc(
        getAllTapPerDay: sl(),
        getTodayTapPerDay: sl(),
        goToRepository: sl(),
        longPress: sl(),
        tap: sl(),
      ),
    )
    // Usecases
    ..registerLazySingleton(() => GetAllTapPerDay(repository: sl()))
    ..registerLazySingleton(() => GetTodayTapPerDay(repository: sl()))
    ..registerLazySingleton(() => GoToRepository(repository: sl()))
    ..registerLazySingleton(() => LongPress(repository: sl()))
    ..registerLazySingleton(() => Tap(repository: sl()))
    // Repository
    ..registerLazySingleton<TapperRepository>(
      () => TapperRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    )
    // Data Sources
    ..registerLazySingleton<TapperLocalDataSource>(
      () => TapperLocalDataSourceImpl(db: sl()),
    )
    ..registerLazySingleton<TapperRemoteDataSource>(
      () => const TapperRemoteDataSourceImpl(),
    );
}
