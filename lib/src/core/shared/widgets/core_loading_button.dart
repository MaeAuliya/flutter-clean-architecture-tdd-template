import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import '../../res/colours.dart';

class CoreLoadingButton extends StatelessWidget {
  const CoreLoadingButton({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: context.heightScale * (height ?? 34),
      ),
      decoration: BoxDecoration(
        color: Colours.darkBlue,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        // vertical: 8,
      ),
      child: const Center(
        child: SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colours.white),
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
