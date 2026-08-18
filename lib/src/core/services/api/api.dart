class API {
  final String baseUrl;
  final ExampleAPI exampleAPI;

  const API({
    this.baseUrl = const String.fromEnvironment('BASE_URL'),
    this.exampleAPI = const ExampleAPI(),
  });

  List<String> missingKeys() => [
    if (baseUrl.trim().isEmpty) 'BASE_URL',
  ];

  void validate() {
    final missing = missingKeys();
    if (missing.isNotEmpty) {
      throw StateError('Missing build configuration: ${missing.join(', ')}');
    }

    final uri = Uri.tryParse(baseUrl);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      throw StateError('Invalid build configuration: BASE_URL must be HTTPS.');
    }
  }
}

class ExampleAPI {
  final String example;

  const ExampleAPI({
    this.example = const String.fromEnvironment('EXAMPLE'),
  });
}
