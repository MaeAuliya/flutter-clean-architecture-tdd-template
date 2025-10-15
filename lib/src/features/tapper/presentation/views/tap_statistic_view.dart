import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/res/colours.dart';
import '../../../../core/res/texts.dart';
import '../../../../core/res/typography.dart';

class TapStatisticView extends StatelessWidget {
  const TapStatisticView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: context.widthScale * 16,
      ),
      child: const Center(
        child: CoreText(
          Texts.statisticsDummyDesc,
          size: 13,
          textAlign: TextAlign.center,
          color: Colours.black,
          maxLines: 10,
        ),
      ),
    );
  }
}
