import '../../file_template.dart';
import '../../name_case.dart';

class InjectorTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import 'package:get_it/get_it.dart';

import '../../../../features/${n.snake}/data/datasources/${n.snake}_local_data_source.dart';
import '../../../../features/${n.snake}/data/datasources/${n.snake}_remote_data_source.dart';
import '../../../../features/${n.snake}/data/repositories/${n.snake}_repository_impl.dart';
import '../../../../features/${n.snake}/domain/repositories/${n.snake}_repository.dart';
import '../../../../features/${n.snake}/domain/usecases/get_${n.snake}.dart';
import '../../../../features/${n.snake}/domain/usecases/update_${n.snake}.dart';
import '../../../../features/${n.snake}/presentation/bloc/${n.snake}_bloc.dart';
import '../injection_container.dart';

class ${n.pascal}Injector implements Injector {
  const ${n.pascal}Injector();

  @override
  Future<void> inject(GetIt sl) async {
    sl
      ..registerFactory(
        () => ${n.pascal}Bloc(
          get${n.pascal}: sl(),
          update${n.pascal}: sl(),
        ),
      )
      ..registerLazySingleton(() => Get${n.pascal}(repository: sl()))
      ..registerLazySingleton(() => Update${n.pascal}(repository: sl()))
      ..registerLazySingleton<${n.pascal}Repository>(
        () => ${n.pascal}RepositoryImpl(
          localDataSource: sl(),
          remoteDataSource: sl(),
          logger: sl(),
        ),
      )
      ..registerLazySingleton<${n.pascal}LocalDataSource>(
        ${n.pascal}LocalDataSourceImpl.new,
      )
      ..registerLazySingleton<${n.pascal}RemoteDataSource>(
        ${n.pascal}RemoteDataSourceImpl.new,
      );
  }
}
''';

  @override
  String moduleTpl(NameCase n) =>
      '''
import 'package:get_it/get_it.dart';

import '../../../modules/${n.snake}/data/datasources/${n.snake}_local_data_source.dart';
import '../../../modules/${n.snake}/data/datasources/${n.snake}_remote_data_source.dart';
import '../../../modules/${n.snake}/data/repositories/${n.snake}_repository_impl.dart';
import '../../../modules/${n.snake}/domain/repositories/${n.snake}_repository.dart';
import '../../../modules/${n.snake}/domain/usecases/get_${n.snake}.dart';
import '../../../modules/${n.snake}/domain/usecases/update_${n.snake}.dart';
import '../injection_container.dart';

class ${n.pascal}ModuleInjector implements Injector {
  const ${n.pascal}ModuleInjector();

  @override
  Future<void> inject(GetIt sl) async {
    sl
      ..registerLazySingleton(() => Get${n.pascal}(repository: sl()))
      ..registerLazySingleton(() => Update${n.pascal}(repository: sl()))
      ..registerLazySingleton<${n.pascal}Repository>(
        () => ${n.pascal}RepositoryImpl(
          localDataSource: sl(),
          remoteDataSource: sl(),
          logger: sl(),
        ),
      )
      ..registerLazySingleton<${n.pascal}LocalDataSource>(
        ${n.pascal}LocalDataSourceImpl.new,
      )
      ..registerLazySingleton<${n.pascal}RemoteDataSource>(
        ${n.pascal}RemoteDataSourceImpl.new,
      );
  }
}
''';
}
