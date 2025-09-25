import 'package:flutter/material.dart';

import '../../res/texts.dart';
import '../../res/typography.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CoreText(Texts.pageUnderConstruction)),
    );
  }
}
