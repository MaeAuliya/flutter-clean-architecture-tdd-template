import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/res/colours.dart';
import '../../../../core/res/fonts.dart';
import '../../../../core/res/typography.dart';
import '../../../navigation/presentation/views/bottom_navigation.dart';
import '../bloc/tapper_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 8), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, BottomNavigationCore.routeName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TapperBloc, TapperState>(
        listener: (context, state) {},
        child: Container(
          width: context.width,
          height: context.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colours.primaryBlue,
                Colours.lightBlue,
              ],
              stops: [0.15, 1],
              begin: Alignment.centerRight,
              end: Alignment.topLeft,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CoreText(
                'Counter++',
                size: 32,
                color: Colours.white,
                weight: CoreTypography.bold,
              ),
              CoreText(
                'Mobile',
                size: 24,
                color: Colours.yellow,
                weight: CoreTypography.bold,
                family: Fonts.satisfy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
