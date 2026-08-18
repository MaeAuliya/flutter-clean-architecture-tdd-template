import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CoreRectangleShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const CoreRectangleShimmer({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Intrinsic loading effect derives contrast from active theme.
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHighest,
      highlightColor: scheme.surfaceContainerLowest,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
