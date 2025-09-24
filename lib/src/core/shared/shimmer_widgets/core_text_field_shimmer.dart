import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../extensions/context_extension.dart';
import '../../res/colours.dart';

class CoreTextFieldShimmer extends StatelessWidget {
  const CoreTextFieldShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colours.gray300,
      highlightColor: Colours.gray100,
      child: Container(
        width: context.width,
        height: context.heightScale * 38,
        decoration: BoxDecoration(
          color: Colours.gray400,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
