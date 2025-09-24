import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

import '../../res/colours.dart';

class CoreAvatarShimmer extends StatelessWidget {
  final double size;

  const CoreAvatarShimmer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colours.gray300,
      highlightColor: Colours.gray100,
      child: Icon(
        CupertinoIcons.profile_circled,
        color: Colours.gray500,
        size: size,
      ),
    );
  }
}
