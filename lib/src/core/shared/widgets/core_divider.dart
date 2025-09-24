import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import '../../res/colours.dart';

class CoreDivider extends StatelessWidget {
  final Color color;
  final double height;

  const CoreDivider({super.key, this.color = Colours.gray200, this.height = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.transparent),
      ),
    );
  }
}
