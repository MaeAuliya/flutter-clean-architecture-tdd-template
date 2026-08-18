import 'dart:io';

import 'name_case.dart';
import 'templates/bloc/bloc_core_template.dart';
import 'templates/bloc/bloc_event_template.dart';
import 'templates/bloc/bloc_state_template.dart';
import 'templates/data/local_data_source_template.dart';
import 'templates/data/model_template.dart';
import 'templates/data/remote_data_source_template.dart';
import 'templates/data/repository_impl_template.dart';
import 'templates/domain/entity_template.dart';
import 'templates/domain/repository_template.dart';
import 'templates/domain/usecase_get_template.dart';
import 'templates/domain/usecase_update_template.dart';
import 'templates/injector/injector_template.dart';
import 'templates/presentation/extensions/context_extension_template.dart';
import 'templates/presentation/screens/screen_template.dart';
import 'templates/presentation/views/view_template.dart';
import 'templates/providers/provider_template.dart';
import 'templates/routes/route_registry_template.dart';
import 'templates/test_templates.dart';

class FileGenHelpers {
  static Future<void> mkdirs(List<String> paths) async {
    for (final p in paths) {
      final d = Directory(p);
      if (!await d.exists()) {
        await d.create(recursive: true);
      }
    }
  }

  static Future<void> write(String path, String content) async {
    final f = File(path);
    await f.parent.create(recursive: true);

    if (await f.exists()) {
      stdout.writeln(' = $path (skipped, already exists)');
      return;
    }

    await f.writeAsString(content);
    stdout.writeln(' + $path');
  }

  // -----------------------------------------------------------------------------
  // Checking if Features and Modules already exist or not
  // -----------------------------------------------------------------------------
  static Future<void> _ensureFeatureDoesNotExist(NameCase name) async {
    final featureDir = Directory('lib/src/features/${name.snake}');

    if (await featureDir.exists()) {
      stderr.writeln(
        '❌ Feature "${name.snake}" already exists at ${featureDir.path}.',
      );
      stderr.writeln(
        'Use a different feature name, or create a separate screen/view generator for existing features.',
      );
      exit(64);
    }
  }

  static Future<void> _ensureModuleDoesNotExist(NameCase name) async {
    final moduleDir = Directory('lib/src/core/modules/${name.snake}');

    if (await moduleDir.exists()) {
      stderr.writeln(
        '❌ Module "${name.snake}" already exists at ${moduleDir.path}.',
      );
      stderr.writeln(
        'Use a different module name, or update the existing module manually.',
      );
      exit(64);
    }
  }

  // -----------------------------------------------------------------------------
  // Auto-integrate Injector into injection_container.dart
  // -----------------------------------------------------------------------------
  static Future<void> _integrateInjector(
    NameCase name, {
    bool isModule = false,
  }) async {
    final containerPath =
        'lib/src/core/services/injection/injection_container.dart';
    final containerFile = File(containerPath);

    if (!await containerFile.exists()) {
      stderr.writeln(
        '❌ injection_container.dart not found. Run file gen core first.',
      );
      return;
    }

    var text = await containerFile.readAsString();

    // Adding import at its stable marker.
    final importLine = isModule
        ? "import 'injectors/${name.snake}_module_injector.dart';"
        : "import 'injectors/${name.snake}_injector.dart';";
    const importMarker = '// GENERATED INJECTOR IMPORTS - DO NOT REMOVE';

    if (!text.contains(importLine)) {
      if (!text.contains(importMarker)) {
        stderr.writeln(
          '❌ Injector import marker not found in injection_container.dart.',
        );
        exit(64);
      }
      text = text.replaceFirst(importMarker, '$importLine\n$importMarker');
    }

    // Adding Injector instance at its stable marker.
    final marker = isModule
        ? '// GENERATED MODULE INJECTORS - DO NOT REMOVE'
        : '// GENERATED FEATURE INJECTORS - DO NOT REMOVE';
    final injectorEntry = isModule
        ? '${name.pascal}ModuleInjector(),'
        : '${name.pascal}Injector(),';

    if (!text.contains(injectorEntry)) {
      if (!text.contains(marker)) {
        stderr.writeln(
          '❌ Injector marker not found in injection_container.dart.',
        );
        exit(64);
      }
      text = text.replaceFirst(marker, '$injectorEntry\n    $marker');
    }

    await containerFile.writeAsString(text);
    stdout.writeln(
      '✅ Integrated ${name.pascal}Injector into injection_container.dart',
    );
  }

  // -----------------------------------------------------------------------------
  // Auto-integrate Router into app_router.dart
  // -----------------------------------------------------------------------------
  static Future<void> _integrateRouteRegistry(NameCase name) async {
    const routeAggregatorPath = 'lib/src/core/services/router/app_routes.dart';

    const importMarker =
        '// GENERATED FEATURE ROUTE REGISTRY IMPORTS - DO NOT REMOVE';

    const registryMarker =
        '// GENERATED FEATURE ROUTE REGISTRIES - DO NOT REMOVE';

    final file = File(routeAggregatorPath);

    if (!await file.exists()) {
      stderr.writeln('❌ app_routes.dart not found at $routeAggregatorPath.');
      return;
    }

    var text = await file.readAsString();

    final importLine = "import 'registries/${name.snake}_route_registry.dart';";

    final registryEntry = '${name.pascal}RouteRegistry(),';

    if (!text.contains(importLine)) {
      if (!text.contains(importMarker)) {
        stderr.writeln(
          '❌ Route registry import marker not found in app_routes.dart.',
        );
        return;
      }

      text = text.replaceFirst(
        importMarker,
        '$importLine\n$importMarker',
      );
    }

    if (!text.contains('${name.pascal}RouteRegistry()')) {
      if (!text.contains(registryMarker)) {
        stderr.writeln(
          '❌ Route registry marker not found in app_routes.dart.',
        );
        return;
      }

      text = text.replaceFirst(
        registryMarker,
        '$registryEntry\n    $registryMarker',
      );
    }

    await file.writeAsString(text);

    stdout.writeln(
      '✅ Registered ${name.pascal}RouteRegistry in app_routes.dart',
    );
  }

  // -----------------------------------------------------------------------------
  // Module (NO presentation)
  // -----------------------------------------------------------------------------
  static Future<void> generateModule(NameCase n) async {
    await _ensureModuleDoesNotExist(n);

    final base = 'lib/src/core/modules/${n.snake}';

    await mkdirs([
      '$base/domain/entities',
      '$base/domain/repositories',
      '$base/domain/usecases',
      '$base/data/models',
      '$base/data/datasources',
      '$base/data/repositories',
    ]);

    await write(
      '$base/domain/entities/${n.snake}_entity.dart',
      EntityTemplate().moduleTpl(n),
    );
    await write(
      '$base/domain/repositories/${n.snake}_repository.dart',
      RepositoryTemplate().moduleTpl(n),
    );
    await write(
      '$base/domain/usecases/get_${n.snake}.dart',
      UsecaseGetTemplate().moduleTpl(n),
    );
    await write(
      '$base/domain/usecases/update_${n.snake}.dart',
      UsecaseUpdateTemplate().moduleTpl(n),
    );

    await write(
      '$base/data/models/${n.snake}_model.dart',
      ModelTemplate().moduleTpl(n),
    );
    await write(
      '$base/data/datasources/${n.snake}_local_data_source.dart',
      LocalDataSourceTemplate().moduleTpl(n),
    );
    await write(
      '$base/data/datasources/${n.snake}_remote_data_source.dart',
      RemoteDataSourceTemplate().moduleTpl(n),
    );
    await write(
      '$base/data/repositories/${n.snake}_repository_impl.dart',
      RepositoryImplTemplate().moduleTpl(n),
    );

    await write(
      'lib/src/core/services/injection/injectors/${n.snake}_module_injector.dart',
      InjectorTemplate().moduleTpl(n),
    );
    await _generateTests(
      n,
      sourcePrefix: 'src/core/modules/${n.snake}',
      testPrefix: 'test/core/modules/${n.snake}',
      includeBloc: false,
    );

    await _integrateInjector(n, isModule: true);
  }

  // -----------------------------------------------------------------------------
  // Feature (WITH presentation, BLoC & Providers)
  // -----------------------------------------------------------------------------
  static Future<void> generateFeature(NameCase n) async {
    await _ensureFeatureDoesNotExist(n);

    final base = 'lib/src/features/${n.snake}';

    await mkdirs([
      '$base/domain/entities',
      '$base/domain/repositories',
      '$base/domain/usecases',
      '$base/data/models',
      '$base/data/datasources',
      '$base/data/repositories',
      '$base/presentation/bloc',
      '$base/presentation/extensions',
      '$base/presentation/providers',
      '$base/presentation/screens',
      '$base/presentation/views',
      '$base/presentation/widgets',
    ]);

    await write(
      '$base/domain/entities/${n.snake}_entity.dart',
      EntityTemplate().featureTpl(n),
    );
    await write(
      '$base/domain/repositories/${n.snake}_repository.dart',
      RepositoryTemplate().featureTpl(n),
    );
    await write(
      '$base/domain/usecases/get_${n.snake}.dart',
      UsecaseGetTemplate().featureTpl(n),
    );
    await write(
      '$base/domain/usecases/update_${n.snake}.dart',
      UsecaseUpdateTemplate().featureTpl(n),
    );

    await write(
      '$base/data/models/${n.snake}_model.dart',
      ModelTemplate().featureTpl(n),
    );
    await write(
      '$base/data/datasources/${n.snake}_local_data_source.dart',
      LocalDataSourceTemplate().featureTpl(n),
    );
    await write(
      '$base/data/datasources/${n.snake}_remote_data_source.dart',
      RemoteDataSourceTemplate().featureTpl(n),
    );
    await write(
      '$base/data/repositories/${n.snake}_repository_impl.dart',
      RepositoryImplTemplate().featureTpl(n),
    );

    // BLOC
    await write(
      '$base/presentation/bloc/${n.snake}_event.dart',
      BlocEventTemplate().featureTpl(n),
    );
    await write(
      '$base/presentation/bloc/${n.snake}_state.dart',
      BlocStateTemplate().featureTpl(n),
    );
    await write(
      '$base/presentation/bloc/${n.snake}_bloc.dart',
      BlocCoreTemplate().featureTpl(n),
    );

    // PROVIDER
    await write(
      '$base/presentation/providers/${n.snake}_provider.dart',
      ProviderTemplate().featureTpl(n),
    );

    await write(
      '$base/presentation/extensions/${n.snake}_context_extension.dart',
      ContextExtensionTemplate().featureTpl(n),
    );

    await write(
      '$base/presentation/views/${n.snake}_view.dart',
      ViewTemplate().featureTpl(n),
    );
    await write(
      '$base/presentation/screens/${n.snake}_screen.dart',
      ScreenTemplate().featureTpl(n),
    );

    await write(
      'lib/src/core/services/injection/injectors/${n.snake}_injector.dart',
      InjectorTemplate().featureTpl(n),
    );

    await write(
      'lib/src/core/services/router/registries/${n.snake}_route_registry.dart',
      RouteRegistryTemplate().featureTpl(n),
    );

    await _generateTests(
      n,
      sourcePrefix: 'src/features/${n.snake}',
      testPrefix: 'test/features/${n.snake}',
      includeBloc: true,
    );

    await _integrateInjector(n);
    await _integrateRouteRegistry(n);
  }

  static Future<void> _generateTests(
    NameCase n, {
    required String sourcePrefix,
    required String testPrefix,
    required bool includeBloc,
  }) async {
    await write(
      '$testPrefix/domain/repositories/${n.snake}_repository.mock.dart',
      TestTemplates.repositoryMock(n, sourcePrefix: sourcePrefix),
    );
    await write(
      '$testPrefix/domain/usecases/get_${n.snake}_test.dart',
      TestTemplates.getUseCaseTest(n, sourcePrefix: sourcePrefix),
    );
    await write(
      '$testPrefix/domain/usecases/update_${n.snake}_test.dart',
      TestTemplates.updateUseCaseTest(n, sourcePrefix: sourcePrefix),
    );
    await write(
      '$testPrefix/data/datasources/${n.snake}_data_source.mock.dart',
      TestTemplates.dataSourceMocks(n, sourcePrefix: sourcePrefix),
    );
    await write(
      '$testPrefix/data/datasources/${n.snake}_data_source_test.dart',
      TestTemplates.dataSourceTest(n, sourcePrefix: sourcePrefix),
    );
    await write(
      '$testPrefix/data/repositories/${n.snake}_repository_impl_test.dart',
      TestTemplates.repositoryTest(n, sourcePrefix: sourcePrefix),
    );

    if (!includeBloc) return;

    await write(
      '$testPrefix/presentation/bloc/${n.snake}_usecase.mock.dart',
      TestTemplates.useCaseMocks(n, sourcePrefix: sourcePrefix),
    );
    await write(
      '$testPrefix/presentation/bloc/${n.snake}_bloc_test.dart',
      TestTemplates.blocTest(n, sourcePrefix: sourcePrefix),
    );
  }
}
