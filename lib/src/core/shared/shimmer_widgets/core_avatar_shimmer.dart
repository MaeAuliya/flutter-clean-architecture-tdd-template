import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CoreAvatarShimmer extends StatelessWidget {
  final double size;

  const CoreAvatarShimmer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Intrinsic loading effect derives contrast from active theme.
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHighest,
      highlightColor: scheme.surfaceContainerLowest,
      child: Icon(
        Icons.account_circle_outlined,
        color: scheme.primary,
        size: size,
      ),
    );
  }
}
