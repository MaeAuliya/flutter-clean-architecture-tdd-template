import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/core/res/app_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Mobile Orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // // Init Dependencies
  // await initialization();

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
        // ChangeNotifierProvider(create: (_) => ExampleProvider()),
      ],
      child: MaterialApp(
        title: 'ShareCar for Business',
        showPerformanceOverlay: false,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        onGenerateRoute: (settings) => generateRoute(settings),
        initialRoute: SplashScreen.routeName,
        navigatorKey: navigatorKey,
        navigatorObservers: [
          sl<RouteObserver<ModalRoute<void>>>(),
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
