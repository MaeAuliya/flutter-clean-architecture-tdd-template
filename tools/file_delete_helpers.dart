import 'dart:io';

import 'name_case.dart';

class FileDeleteHelpers {
  const FileDeleteHelpers._();

  static Future<void> deleteFeature(NameCase name) async {
    await _ensureFeatureExists(name);

    final confirmed = _confirmDeleteFeature(name);

    if (!confirmed) {
      stdout.writeln('Delete cancelled.');
      return;
    }

    await _deleteDirectoryIfExists(
      'lib/src/features/${name.snake}',
    );

    await _deleteFileIfExists(
      'lib/src/core/services/injection/injectors/${name.snake}_injector.dart',
    );

    await _deleteFileIfExists(
      'lib/src/core/services/router/registries/${name.snake}_route_registry.dart',
    );

    await _removeFeatureInjectorRegistration(name);
    await _removeProviderRegistration(name);
    await _removeRouteRegistryRegistration(name);

    stdout.writeln('');
    stdout.writeln('✅ Deleted feature "${name.snake}".');
    _printNextSteps();
  }

  static Future<void> deleteModule(NameCase name) async {
    await _ensureModuleExists(name);

    final confirmed = _confirmDeleteModule(name);

    if (!confirmed) {
      stdout.writeln('Delete cancelled.');
      return;
    }

    await _deleteDirectoryIfExists(
      'lib/src/core/modules/${name.snake}',
    );

    await _deleteFileIfExists(
      'lib/src/core/services/injection/injectors/${name.snake}_module_injector.dart',
    );

    await _removeModuleInjectorRegistration(name);

    stdout.writeln('');
    stdout.writeln('✅ Deleted module "${name.snake}".');
    _printNextSteps();
  }

  static Future<void> _ensureFeatureExists(NameCase name) async {
    final featureDir = Directory('lib/src/features/${name.snake}');

    if (!await featureDir.exists()) {
      stderr.writeln(
        '❌ Feature "${name.snake}" does not exist at ${featureDir.path}.',
      );
      exit(64);
    }
  }

  static Future<void> _ensureModuleExists(NameCase name) async {
    final moduleDir = Directory('lib/src/core/modules/${name.snake}');

    if (!await moduleDir.exists()) {
      stderr.writeln(
        '❌ Module "${name.snake}" does not exist at ${moduleDir.path}.',
      );
      exit(64);
    }
  }

  static bool _confirmDeleteFeature(NameCase name) {
    stdout.writeln('');
    stdout.writeln('⚠️ You are about to delete feature "${name.snake}".');
    stdout.writeln('This will remove:');
    stdout.writeln('- lib/src/features/${name.snake}');
    stdout.writeln(
      '- lib/src/core/services/injection/injectors/${name.snake}_injector.dart',
    );
    stdout.writeln(
      '- lib/src/core/services/router/registries/${name.snake}_route_registry.dart',
    );
    stdout.writeln('- related entries in injection_container.dart');
    stdout.writeln('- related entries in app_providers.dart');
    stdout.writeln('- related entries in app_routes.dart');
    stdout.writeln('');
    stdout.write('Type DELETE ${name.snake} to confirm: ');

    final input = stdin.readLineSync();

    return input == 'DELETE ${name.snake}';
  }

  static bool _confirmDeleteModule(NameCase name) {
    stdout.writeln('');
    stdout.writeln('⚠️ You are about to delete module "${name.snake}".');
    stdout.writeln('This will remove:');
    stdout.writeln('- lib/src/core/modules/${name.snake}');
    stdout.writeln(
      '- lib/src/core/services/injection/injectors/${name.snake}_module_injector.dart',
    );
    stdout.writeln('- related entries in injection_container.dart');
    stdout.writeln('');
    stdout.write('Type DELETE ${name.snake} to confirm: ');

    final input = stdin.readLineSync();

    return input == 'DELETE ${name.snake}';
  }

  static Future<void> _deleteDirectoryIfExists(String path) async {
    final dir = Directory(path);

    if (!await dir.exists()) {
      stdout.writeln(' = $path (skipped, not found)');
      return;
    }

    await dir.delete(recursive: true);
    stdout.writeln(' - $path');
  }

  static Future<void> _deleteFileIfExists(String path) async {
    final file = File(path);

    if (!await file.exists()) {
      stdout.writeln(' = $path (skipped, not found)');
      return;
    }

    await file.delete();
    stdout.writeln(' - $path');
  }

  static Future<void> _removeFeatureInjectorRegistration(NameCase name) async {
    const path = 'lib/src/core/services/injection/injection_container.dart';

    final file = File(path);

    if (!await file.exists()) {
      stdout.writeln(' = $path (skipped, not found)');
      return;
    }

    var text = await file.readAsString();

    final importLine = "import 'injectors/${name.snake}_injector.dart';";
    final injectorEntry = '${name.pascal}Injector(),';

    text = _removeLine(text, importLine);
    text = _removeLine(text, injectorEntry);

    await file.writeAsString(text);

    stdout.writeln(' ~ cleaned $path');
  }

  static Future<void> _removeModuleInjectorRegistration(NameCase name) async {
    const path = 'lib/src/core/services/injection/injection_container.dart';

    final file = File(path);

    if (!await file.exists()) {
      stdout.writeln(' = $path (skipped, not found)');
      return;
    }

    var text = await file.readAsString();

    final importLine = "import 'injectors/${name.snake}_module_injector.dart';";
    final injectorEntry = '${name.pascal}ModuleInjector(),';

    text = _removeLine(text, importLine);
    text = _removeLine(text, injectorEntry);

    await file.writeAsString(text);

    stdout.writeln(' ~ cleaned $path');
  }

  static Future<void> _removeProviderRegistration(NameCase name) async {
    const path = 'lib/src/core/services/providers/app_providers.dart';

    final file = File(path);

    if (!await file.exists()) {
      stdout.writeln(' = $path (skipped, not found)');
      return;
    }

    var text = await file.readAsString();

    final importLine =
        "import '../../../features/${name.snake}/presentation/providers/${name.snake}_provider.dart';";

    final providerEntry =
        'ChangeNotifierProvider(create: (_) => ${name.pascal}Provider()),';

    text = _removeLine(text, importLine);

    final providerEntryWithCommentRegex = RegExp(
      r'^\s*///\s*' +
          RegExp.escape('${name.title} Feature') +
          r'\s*\r?\n\s*' +
          RegExp.escape(providerEntry) +
          r'\s*\r?\n?',
      multiLine: true,
    );

    text = text.replaceAll(providerEntryWithCommentRegex, '');
    text = _removeLine(text, providerEntry);

    await file.writeAsString(text);

    stdout.writeln(' ~ cleaned $path');
  }

  static Future<void> _removeRouteRegistryRegistration(NameCase name) async {
    const path = 'lib/src/core/services/router/app_routes.dart';

    final file = File(path);

    if (!await file.exists()) {
      stdout.writeln(' = $path (skipped, not found)');
      return;
    }

    var text = await file.readAsString();

    final importLine = "import 'registries/${name.snake}_route_registry.dart';";
    final registryEntry = '${name.pascal}RouteRegistry(),';

    text = _removeLine(text, importLine);
    text = _removeLine(text, registryEntry);

    await file.writeAsString(text);

    stdout.writeln(' ~ cleaned $path');
  }

  static String _removeLine(String text, String line) {
    final lineRegex = RegExp(
      r'^\s*' + RegExp.escape(line) + r'\s*\r?\n?',
      multiLine: true,
    );

    return text.replaceAll(lineRegex, '');
  }

  static void _printNextSteps() {
    stdout.writeln('');
    stdout.writeln('Next steps:');
    stdout.writeln('  dart format .');
    stdout.writeln('  flutter analyze');
  }
}
