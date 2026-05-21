class NameCase {
  final String raw;

  NameCase(this.raw);

  String get snake => raw
      .trim()
      .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
      .replaceAll(RegExp(r'__+'), '_')
      .toLowerCase();

  String get upperSnake => snake.toUpperCase();

  String get kebab => snake.replaceAll('_', '-');

  String get pascal => snake
      .split('_')
      .where((s) => s.isNotEmpty)
      .map((s) => s[0].toUpperCase() + s.substring(1))
      .join();

  String get camel =>
      pascal.isEmpty ? '' : pascal[0].toLowerCase() + pascal.substring(1);

  String get title => snake
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');

  bool get isValid {
    if (snake.isEmpty) return false;

    if (RegExp(r'^[0-9]').hasMatch(snake)) return false;

    return RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(snake);
  }
}
