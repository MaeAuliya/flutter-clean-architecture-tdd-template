import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/res/colours.dart';
import '../views/tap_statistic_view.dart';

class TapStatisticScreen extends StatefulWidget {
  const TapStatisticScreen({super.key});

  static const routeName = '/tap-statistic';

  @override
  State<TapStatisticScreen> createState() => _TapStatisticScreenState();
}

class _TapStatisticScreenState extends State<TapStatisticScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colours.gray200,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: TapStatisticView(),
      ),
    );
  }
}
