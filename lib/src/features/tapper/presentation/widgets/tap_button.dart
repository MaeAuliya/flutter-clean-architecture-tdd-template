import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/res/colours.dart';
import '../../../../core/res/typography.dart';

class TapButton extends StatelessWidget {
  final void Function() onTap;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;
  final IconData iconData;
  final String text;

  const TapButton({
    super.key,
    required this.onTap,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.iconData,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: (_) => onLongPressStart(),
      onLongPressEnd: (_) => onLongPressEnd(),
      onLongPressCancel: onLongPressEnd,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colours.primaryBlue,
        ),
        child: Row(
          spacing: context.widthScale * 12,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              weight: 12,
            ),
            CoreText(
              text,
              color: Colors.white,
              size: 14,
              weight: CoreTypography.semiBold,
            ),
          ],
        ),
      ),
    );
  }
}
