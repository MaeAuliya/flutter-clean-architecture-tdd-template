part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<TapperBloc>(),
          child: const SplashScreen(),
        ),
        settings: settings,
      );
    case TapStatisticScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<TapperBloc>(),
          child: const TapStatisticScreen(),
        ),
        settings: settings,
      );
    // Bottom Navigation
    case BottomNavigationCore.routeName:
      return _pageBuilder(
        (_) => const BottomNavigationCore(),
        settings: settings,
      );
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
