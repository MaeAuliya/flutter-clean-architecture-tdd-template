import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../features/template/presentation/bloc/template_bloc.dart';
import '../../../../features/template/presentation/providers/template_provider.dart';
import '../../../../features/template/presentation/screens/splash_screen.dart';
import '../../../../features/template/presentation/screens/template_screen.dart';
import '../../injection/injection_container.dart';
import '../app_route.dart';

class TemplateRouteRegistry implements FeatureRouteRegistry {
  const TemplateRouteRegistry();

  @override
  List<AppRoute> get routes => [
    AppRoute(
      name: SplashScreen.routeName,
      builder: (context, settings) => BlocProvider(
        create: (_) => sl<TemplateBloc>(),
        child: const SplashScreen(),
      ),
    ),
    AppRoute(
      name: TemplateScreen.routeName,
      builder: (context, settings) => MultiProvider(
        providers: [
          BlocProvider(create: (_) => sl<TemplateBloc>()),
          ChangeNotifierProvider(create: (_) => TemplateProvider()),
        ],
        child: const TemplateScreen(),
      ),
    ),

    // GENERATED TEMPLATE FEATURE ROUTES - DO NOT REMOVE
  ];
}
