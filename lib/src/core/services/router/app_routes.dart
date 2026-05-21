import 'app_route.dart';
import 'registries/template_route_registry.dart'; // GENERATED FEATURE ROUTE REGISTRY IMPORTS - DO NOT REMOVE

class AppRoutes {
  const AppRoutes._();

  static const List<FeatureRouteRegistry> _registries = [
    TemplateRouteRegistry(), // GENERATED FEATURE ROUTE REGISTRIES - DO NOT REMOVE
  ];

  static Map<String, AppRouteBuilder> get routeMap => {
    for (final registry in _registries)
      for (final route in registry.routes) route.name: route.builder,
  };
}
