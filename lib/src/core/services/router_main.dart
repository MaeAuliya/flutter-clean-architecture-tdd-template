part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<TemplateBloc>(),
          child: const SplashScreen(),
        ),
        settings: settings,
      );
    case TemplateScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<TemplateBloc>(),
          child: const TemplateScreen(),
        ),
        settings: settings,
      );

    // // Bottom Navigation
    // case BottomNavigationCore.routeName:
    //   return _pageBuilder(
    //     (_) => const BottomNavigationCore(),
    //     settings: settings,
    //   );
    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
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
