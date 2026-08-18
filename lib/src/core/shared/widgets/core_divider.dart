import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';

class CoreDivider extends StatelessWidget {
  final Color? color;
  final double height;

  const CoreDivider({super.key, this.color, this.height = 1});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: height,
      child: ColoredBox(color: color ?? context.colorScheme.outlineVariant),
    );
  }
}
