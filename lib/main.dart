import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'src/core/res/app_theme.dart';
import 'src/core/services/injection/injection_container.dart';
import 'src/core/services/providers/app_providers.dart';
import 'src/core/services/router/router.dart';
import 'src/features/template/presentation/screens/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Mobile Orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Init Dependencies
  await InjectionContainer.init(sl);

  // Run App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'Flutter Clean Architecture TDD Template',
        showPerformanceOverlay: false,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        onGenerateRoute: generateRoute,
        initialRoute: SplashScreen.routeName,
        navigatorKey: navigatorKey,
      ),
    );
  }
}
