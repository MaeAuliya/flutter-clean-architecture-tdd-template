import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../res/colours.dart';

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
    return Shimmer.fromColors(
      baseColor: Colours.gray300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colours.gray400,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
