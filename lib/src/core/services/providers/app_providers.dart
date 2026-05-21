import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../features/template/presentation/providers/template_provider.dart'; // GENERATED FEATURE PROVIDER IMPORTS - DO NOT REMOVE

class AppProviders {
  const AppProviders._();

  static List<SingleChildWidget> get providers => [
    /// Example Features
    ChangeNotifierProvider(create: (_) => TemplateProvider()),
    // ChangeNotifierProvider(create: (_) => ExampleProvider()),
    // GENERATED FEATURE PROVIDERS - DO NOT REMOVE
  ];
}
