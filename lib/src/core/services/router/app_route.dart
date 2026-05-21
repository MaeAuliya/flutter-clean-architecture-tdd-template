import 'package:flutter/widgets.dart';

typedef AppRouteBuilder =
    Widget Function(BuildContext context, RouteSettings settings);

class AppRoute {
  const AppRoute({
    required this.name,
    required this.builder,
  });

  final String name;
  final AppRouteBuilder builder;
}

abstract interface class FeatureRouteRegistry {
  List<AppRoute> get routes;
}
