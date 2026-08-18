import '../name_case.dart';

class TestTemplates {
  const TestTemplates._();

  static String repositoryMock(NameCase n, {required String sourcePrefix}) =>
      '''
import 'package:flutter_clean_tdd_template/$sourcePrefix/domain/repositories/${n.snake}_repository.dart';
import 'package:mocktail/mocktail.dart';

class Mock${n.pascal}Repository extends Mock implements ${n.pascal}Repository {}
''';

  static String dataSourceMocks(NameCase n, {required String sourcePrefix}) =>
      '''
import 'package:flutter_clean_tdd_template/$sourcePrefix/data/datasources/${n.snake}_local_data_source.dart';
import 'package:flutter_clean_tdd_template/$sourcePrefix/data/datasources/${n.snake}_remote_data_source.dart';
import 'package:flutter_clean_tdd_template/src/core/services/logging/app_logger.dart';
import 'package:mocktail/mocktail.dart';

class Mock${n.pascal}LocalDataSource extends Mock
    implements ${n.pascal}LocalDataSource {}

class Mock${n.pascal}RemoteDataSource extends Mock
    implements ${n.pascal}RemoteDataSource {}

class MockAppLogger extends Mock implements AppLogger {}
''';

  static String useCaseMocks(NameCase n, {required String sourcePrefix}) =>
      '''
import 'package:flutter_clean_tdd_template/$sourcePrefix/domain/usecases/get_${n.snake}.dart';
import 'package:flutter_clean_tdd_template/$sourcePrefix/domain/usecases/update_${n.snake}.dart';
import 'package:mocktail/mocktail.dart';

class MockGet${n.pascal} extends Mock implements Get${n.pascal} {}

class MockUpdate${n.pascal} extends Mock implements Update${n.pascal} {}
''';

  static String getUseCaseTest(NameCase n, {required String sourcePrefix}) =>
      '''
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_tdd_template/$sourcePrefix/domain/entities/${n.snake}_entity.dart';
import 'package:flutter_clean_tdd_template/$sourcePrefix/domain/usecases/get_${n.snake}.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/${n.snake}_repository.mock.dart';

void main() {
  late Mock${n.pascal}Repository repository;
  late Get${n.pascal} useCase;

  setUp(() {
    repository = Mock${n.pascal}Repository();
    useCase = Get${n.pascal}(repository: repository);
  });

  test('returns repository result', () async {
    const entity = ${n.pascal}Entity();
    when(() => repository.get${n.pascal}()).thenAnswer(
      (_) async => const Right(entity),
    );

    expect(await useCase(), const Right(entity));
    verify(() => repository.get${n.pascal}()).called(1);
  });
}
''';

  static String updateUseCaseTest(NameCase n, {required String sourcePrefix}) =>
      '''
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_tdd_template/$sourcePrefix/domain/entities/${n.snake}_entity.dart';
import 'package:flutter_clean_tdd_template/$sourcePrefix/domain/usecases/update_${n.snake}.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/${n.snake}_repository.mock.dart';

void main() {
  late Mock${n.pascal}Repository repository;
  late Update${n.pascal} useCase;

  setUp(() {
    repository = Mock${n.pascal}Repository();
    useCase = Update${n.pascal}(repository: repository);
  });

  test('returns repository result', () async {
    const entity = ${n.pascal}Entity();
    when(() => repository.update${n.pascal}(entity)).thenAnswer(
      (_) async => const Right(null),
    );

    expect(await useCase(entity), const Right(null));
    verify(() => repository.update${n.pascal}(entity)).called(1);
  });
}
''';

  static String dataSourceTest(NameCase n, {required String sourcePrefix}) =>
      '''
import 'package:flutter_clean_tdd_template/$sourcePrefix/data/datasources/${n.snake}_local_data_source.dart';
import 'package:flutter_clean_tdd_template/$sourcePrefix/data/datasources/${n.snake}_remote_data_source.dart';
import 'package:flutter_clean_tdd_template/$sourcePrefix/domain/entities/${n.snake}_entity.dart';
import 'package:flutter_clean_tdd_template/src/core/errors/exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('local placeholder throws typed exception', () async {
    const dataSource = ${n.pascal}LocalDataSourceImpl();

    await expectLater(
      dataSource.get${n.pascal}(),
      throwsA(isA<LocalException>()),
    );
  });

  test('remote placeholder throws typed exception', () async {
    const dataSource = ${n.pascal}RemoteDataSourceImpl();

    await expectLater(
      dataSource.update${n.pascal}(const ${n.pascal}Entity()),
      throwsA(isA<ServerException>()),
    );
  });
}
''';

  static String repositoryTest(NameCase n, {required String sourcePrefix}) =>
      '''
import 'package:flutter_clean_tdd_template/$sourcePrefix/data/repositories/${n.snake}_repository_impl.dart';
import 'package:flutter_clean_tdd_template/$sourcePrefix/domain/entities/${n.snake}_entity.dart';
import 'package:flutter_clean_tdd_template/src/core/errors/exception.dart';
import 'package:flutter_clean_tdd_template/src/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../datasources/${n.snake}_data_source.mock.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Exception('fallback error'));
    registerFallbackValue(StackTrace.empty);
  });

  late Mock${n.pascal}LocalDataSource localDataSource;
  late Mock${n.pascal}RemoteDataSource remoteDataSource;
  late MockAppLogger logger;
  late ${n.pascal}RepositoryImpl repository;

  setUp(() {
    localDataSource = Mock${n.pascal}LocalDataSource();
    remoteDataSource = Mock${n.pascal}RemoteDataSource();
    logger = MockAppLogger();
    repository = ${n.pascal}RepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
      logger: logger,
    );
  });

  test('maps local exception to StorageFailure', () async {
    const exception = LocalException(diagnosticMessage: 'diagnostic');
    when(() => localDataSource.get${n.pascal}()).thenThrow(exception);

    final result = await repository.get${n.pascal}();

    expect(result.fold((failure) => failure, (_) => null), isA<StorageFailure>());
    verify(
      () => logger.nonFatal(
        exception,
        any(),
        reason: 'Load ${n.pascal} failed',
      ),
    ).called(1);
  });

  test('maps remote exception to ServerFailure', () async {
    const entity = ${n.pascal}Entity();
    const exception = ServerException.rejected(
      diagnosticMessage: 'diagnostic',
    );
    when(() => remoteDataSource.update${n.pascal}(entity)).thenThrow(exception);

    final result = await repository.update${n.pascal}(entity);

    expect(result.fold((failure) => failure, (_) => null), isA<ServerFailure>());
    verify(
      () => logger.nonFatal(
        exception,
        any(),
        reason: 'Update ${n.pascal} failed',
      ),
    ).called(1);
  });

  test('treats request cancellation as expected control flow', () async {
    const entity = ${n.pascal}Entity();
    when(
      () => remoteDataSource.update${n.pascal}(entity),
    ).thenThrow(const RequestCancelledException());

    final result = await repository.update${n.pascal}(entity);

    expect(result.isRight(), isTrue);
    verifyNever(
      () => logger.nonFatal(
        any<Exception>(),
        any(),
        reason: any(named: 'reason'),
      ),
    );
  });
}
''';

  static String blocTest(NameCase n, {required String sourcePrefix}) =>
      '''
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_tdd_template/$sourcePrefix/domain/entities/${n.snake}_entity.dart';
import 'package:flutter_clean_tdd_template/$sourcePrefix/presentation/bloc/${n.snake}_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '${n.snake}_usecase.mock.dart';

void main() {
  late MockGet${n.pascal} get${n.pascal};
  late MockUpdate${n.pascal} update${n.pascal};

  setUp(() {
    get${n.pascal} = MockGet${n.pascal}();
    update${n.pascal} = MockUpdate${n.pascal}();
  });

  ${n.pascal}Bloc buildBloc() => ${n.pascal}Bloc(
    get${n.pascal}: get${n.pascal},
    update${n.pascal}: update${n.pascal},
  );

  test('starts in ${n.pascal}Initial', () {
    final bloc = buildBloc();
    addTearDown(bloc.close);

    expect(bloc.state, const ${n.pascal}Initial());
  });

  blocTest<${n.pascal}Bloc, ${n.pascal}State>(
    'emits loading and success for Get${n.pascal}Event',
    setUp: () {
      when(() => get${n.pascal}()).thenAnswer(
        (_) async => const Right(${n.pascal}Entity()),
      );
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const Get${n.pascal}Event()),
    expect: () => const [
      ${n.pascal}Loading(),
      Get${n.pascal}Success(${n.pascal}Entity()),
    ],
  );
}
''';
}
