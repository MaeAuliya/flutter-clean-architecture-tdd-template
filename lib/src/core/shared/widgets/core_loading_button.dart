import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';

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
    final scheme = context.colorScheme;
    return Container(
      constraints: BoxConstraints(
        maxHeight: context.heightScale * (height ?? 34),
      ),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(
        child: SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(
            color: scheme.onPrimary,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
