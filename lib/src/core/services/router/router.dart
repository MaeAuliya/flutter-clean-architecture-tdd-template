import 'package:flutter/widgets.dart';

import '../../shared/screens/page_under_construction.dart';
import 'app_routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final routeBuilder = AppRoutes.routeMap[settings.name];

  if (routeBuilder != null) {
    return _pageBuilder(
      (context) => routeBuilder(context, settings),
      settings: settings,
    );
  }

  return _pageBuilder(
    (_) => const PageUnderConstruction(),
    settings: settings,
  );
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings? settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, _, __) => page(context),
    barrierDismissible: false,
  );
}
