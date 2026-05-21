# File Generation Pattern

This project provides local Dart-based file generation tools for creating Clean Architecture features and modules.

## Commands

Create a new feature:

```bash
dart run tools/file_gen_main.dart feature <feature_name>
```

Create a new module:

```bash
dart run tools/file_gen_main.dart module <module_name>
```

Delete an existing feature:

```bash
dart run tools/file_gen_main.dart delete feature <feature_name>
```

Delete an existing module:

```bash
dart run tools/file_gen_main.dart delete module <module_name>
```

## Naming Rules

Use lowercase words separated by underscores.

Examples:

```bash
dart run tools/file_gen_main.dart feature user_profile
dart run tools/file_gen_main.dart feature asset_category
dart run tools/file_gen_main.dart module local_storage
```

Generated names follow:

```text
folder = snake_case
file   = snake_case
class  = PascalCase
var    = camelCase
```

## Feature Generator

The feature generator creates:

- Data layer files
- Domain layer files
- Presentation layer files
- Provider file
- Screen and view files
- Injector file
- Route registry file
- Provider registry entry
- Route registry entry
- Dependency injection registry entry

## Module Generator

The module generator creates reusable module files under:

```text
lib/src/core/modules/<module_name>
```

Modules should not contain presentation layer files.

## Delete Generator

The delete command removes generated files and cleans related registry entries.

Before deleting, the command asks for confirmation.

## AI Guidance

AI agents must use the file generator when creating new features or modules.

Do not manually create Clean Architecture boilerplate unless the generator does not support the requested structure.

After generating or deleting files, run:

```bash
dart format .
flutter analyze
```
