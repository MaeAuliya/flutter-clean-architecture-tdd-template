import 'dart:io';

import 'file_delete_helpers.dart';
import 'file_gen_helpers.dart';
import 'name_case.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    _printUsage();
    exit(64);
  }

  final command = args.first;

  if (command == 'delete') {
    await _handleDeleteCommand(args);
    return;
  }

  await _handleGenerateCommand(args);
}

Future<void> _handleGenerateCommand(List<String> args) async {
  final command = args.first;
  final raw = args.length >= 2 ? args.skip(1).join('_') : '';
  final name = NameCase(raw);

  _validateName(raw, name);

  switch (command) {
    case 'feature':
      await FileGenHelpers.generateFeature(name);
      return;

    case 'module':
      await FileGenHelpers.generateModule(name);
      return;

    default:
      stderr.writeln('❌ Unknown command "$command".');
      _printUsage();
      exit(64);
  }
}

Future<void> _handleDeleteCommand(List<String> args) async {
  if (args.length < 3) {
    stderr.writeln(
      '❌ Invalid delete command.',
    );
    _printUsage();
    exit(64);
  }

  final target = args[1];
  final raw = args.skip(2).join('_');
  final name = NameCase(raw);

  _validateName(raw, name);

  switch (target) {
    case 'feature':
      await FileDeleteHelpers.deleteFeature(name);
      return;

    case 'module':
      await FileDeleteHelpers.deleteModule(name);
      return;

    default:
      stderr.writeln(
        '❌ Unsupported delete target "$target". Supported targets: feature, module.',
      );
      _printUsage();
      exit(64);
  }
}

void _validateName(String raw, NameCase name) {
  if (!name.isValid) {
    stderr.writeln(
      '❌ Invalid name "$raw". The name must start with a letter and may only contain letters, numbers, spaces, hyphens (-), or underscores (_).',
    );
    exit(64);
  }
}

void _printUsage() {
  stderr.writeln('Usage:');
  stderr.writeln('  dart run tools/file_gen_main.dart feature <name>');
  stderr.writeln('  dart run tools/file_gen_main.dart module <name>');
  stderr.writeln('  dart run tools/file_gen_main.dart delete feature <name>');
  stderr.writeln('  dart run tools/file_gen_main.dart delete module <name>');
}
