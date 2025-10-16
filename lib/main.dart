import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'src/core/res/app_theme.dart';
import 'src/core/services/injection_container.dart';
import 'src/core/services/router.dart';
import 'src/features/template/presentation/providers/template_provider.dart';
import 'src/features/template/presentation/screens/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Mobile Orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // // Init Dependencies
  await initDependencies();

  // Run App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Example Features
        ChangeNotifierProvider(create: (_) => TemplateProvider()),
        // ChangeNotifierProvider(create: (_) => ExampleProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Clean Architecture TDD Template',
        showPerformanceOverlay: false,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        onGenerateRoute: generateRoute,
        initialRoute: SplashScreen.routeName,
        navigatorKey: navigatorKey,
        navigatorObservers: [
          // sl<MyRouteObserver>(),
        ],
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.of(
                context,
              ).textScaler.clamp(minScaleFactor: 1, maxScaleFactor: 1),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
