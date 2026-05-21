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
import 'templates/presentation/screens/screen_template.dart';
import 'templates/presentation/views/view_template.dart';
import 'templates/providers/provider_template.dart';
import 'templates/routes/route_registry_template.dart';

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

    // Adding import lines
    final importLine = (isModule)
        ? "import 'injectors/${name.snake}_module_injector.dart';"
        : "import 'injectors/${name.snake}_injector.dart';";
    final importRegex = RegExp(r"^import .+;$", multiLine: true);
    final matches = importRegex.allMatches(text).toList();

    if (!text.contains(importLine)) {
      if (matches.isNotEmpty) {
        final lastImport = matches.last;
        final insertPos = lastImport.end;
        text = text.replaceRange(insertPos, insertPos, '\n$importLine');
      } else {
        text = '$importLine\n$text';
      }
    }

    // Adding Injector instance to list of injectors
    final listRegex = RegExp(
      r'static\s+const\s+_injectors\s*=\s*<Injector>\s*\[(?<body>[\s\S]*?)\];',
    );
    final match = listRegex.firstMatch(text);
    final injectorEntry = (isModule)
        ? ' ${name.pascal}ModuleInjector(),'
        : ' ${name.pascal}Injector(),';

    if (match != null) {
      final body = match.namedGroup('body')!;
      if (!body.contains(injectorEntry.trim())) {
        final newBody = body.trim().isEmpty
            ? ' $injectorEntry\n'
            : '$body $injectorEntry\n ';
        text = text.replaceRange(
          match.start,
          match.end,
          match.group(0)!.replaceFirst(body, newBody),
        );
      }
    } else {
      stderr.writeln(
        '⚠️  Could not find _injectors list in injection_container.dart',
      );
    }

    await containerFile.writeAsString(text);
    stdout.writeln(
      '✅ Integrated ${name.pascal}Injector into injection_container.dart',
    );
  }

  // -----------------------------------------------------------------------------
  // Auto-integrate Providers into app_provider.dart
  // -----------------------------------------------------------------------------
  static Future<void> _integrateProviderRegistry(NameCase name) async {
    const providerRegistryPath =
        'lib/src/core/services/providers/app_providers.dart';

    const importMarker =
        '// GENERATED FEATURE PROVIDER IMPORTS - DO NOT REMOVE';

    const providerMarker = '// GENERATED FEATURE PROVIDERS - DO NOT REMOVE';

    final file = File(providerRegistryPath);

    if (!await file.exists()) {
      stderr.writeln(
        '❌ app_providers.dart not found at $providerRegistryPath.',
      );
      exit(64);
    }

    var text = await file.readAsString();

    final importLine =
        "import '../../../features/${name.snake}/presentation/providers/${name.snake}_provider.dart';";

    final providerEntry =
        '''
        /// ${name.title} Feature
        ChangeNotifierProvider(create: (_) => ${name.pascal}Provider()),
''';

    if (!text.contains(importLine)) {
      if (!text.contains(importMarker)) {
        stderr.writeln(
          '❌ Provider import marker not found in app_providers.dart.',
        );
        exit(64);
      }

      text = text.replaceFirst(
        importMarker,
        '$importLine\n$importMarker',
      );
    }

    if (!text.contains('${name.pascal}Provider()')) {
      if (!text.contains(providerMarker)) {
        stderr.writeln(
          '❌ Provider registry marker not found in app_providers.dart.',
        );
        exit(64);
      }

      text = text.replaceFirst(
        providerMarker,
        '$providerEntry        $providerMarker',
      );
    }

    await file.writeAsString(text);

    stdout.writeln(
      '✅ Registered ${name.pascal}Provider in app_providers.dart',
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

    final registryEntry =
        '''
    ${name.pascal}RouteRegistry(),
''';

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
        '$registryEntry$registryMarker',
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
      EntityTemplate().moduleTpl(n) ?? EntityTemplate().featureTpl(n),
    );
    await write(
      '$base/domain/repositories/${n.snake}_repository.dart',
      RepositoryTemplate().moduleTpl(n) ?? RepositoryTemplate().featureTpl(n),
    );
    await write(
      '$base/domain/usecases/get_${n.snake}.dart',
      UsecaseGetTemplate().moduleTpl(n) ?? UsecaseGetTemplate().featureTpl(n),
    );
    await write(
      '$base/domain/usecases/update_${n.snake}.dart',
      UsecaseUpdateTemplate().moduleTpl(n) ??
          UsecaseUpdateTemplate().featureTpl(n),
    );

    await write(
      '$base/data/models/${n.snake}_model.dart',
      ModelTemplate().moduleTpl(n) ?? ModelTemplate().featureTpl(n),
    );
    await write(
      '$base/data/datasources/${n.snake}_local_data_source.dart',
      LocalDataSourceTemplate().moduleTpl(n) ??
          LocalDataSourceTemplate().featureTpl(n),
    );
    await write(
      '$base/data/datasources/${n.snake}_remote_data_source.dart',
      RemoteDataSourceTemplate().moduleTpl(n) ??
          RemoteDataSourceTemplate().featureTpl(n),
    );
    await write(
      '$base/data/repositories/${n.snake}_repository_impl.dart',
      RepositoryImplTemplate().moduleTpl(n) ??
          RepositoryImplTemplate().featureTpl(n),
    );

    await write(
      'lib/src/core/services/injection/injectors/${n.snake}_module_injector.dart',
      InjectorTemplate().moduleTpl(n) ?? InjectorTemplate().featureTpl(n),
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
    await _integrateProviderRegistry(n);

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

    await _integrateInjector(n);
    await _integrateRouteRegistry(n);
  }
}
