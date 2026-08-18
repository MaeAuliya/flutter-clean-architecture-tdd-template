import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../extensions/context_extension.dart';

class CoreTextFieldShimmer extends StatelessWidget {
  const CoreTextFieldShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    // Intrinsic loading effect derives contrast from active theme.
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHighest,
      highlightColor: scheme.surfaceContainerLowest,
      child: Container(
        width: context.width,
        height: context.heightScale * 38,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
