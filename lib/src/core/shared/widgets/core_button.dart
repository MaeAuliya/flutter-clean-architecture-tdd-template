import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import '../../res/colours.dart';
import '../../res/typography.dart';

class CoreButton extends StatelessWidget {
  const CoreButton({
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    required this.onPressed,
    required this.text,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.horizontalPadding,
    this.verticalPadding,
    this.radius,
    this.icon,
    this.iconPositionFront = true,
    this.isDisable = false,
    this.borderColor,
    this.minimumSize = 34,
    this.underlineTextColor,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback onPressed;
  final String text;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? radius;
  final Icon? icon;
  final bool iconPositionFront;
  final bool isDisable;
  final Color? borderColor;
  final double minimumSize;
  final Color? underlineTextColor;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isDisable,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(minimumSize * context.heightScale),
          shape: RoundedRectangleBorder(
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(radius ?? 4),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 12,
            vertical: verticalPadding ?? 8,
          ),
          backgroundColor: isDisable
              ? Colours.gray300
              : backgroundColor ?? Colours.darkBlue,
          foregroundColor: foregroundColor ?? Colors.white,
          shadowColor: Colors.black.withAlpha(5),
        ),
        onPressed: () async {
          onPressed();
        },
        child: icon == null
            ? CoreText(
                text,
                weight: fontWeight ?? CoreTypography.bold,
                color: foregroundColor ?? Colours.white,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (iconPositionFront) ? icon! : const SizedBox.shrink(),
                  (iconPositionFront)
                      ? SizedBox(width: context.widthScale * 10)
                      : const SizedBox.shrink(),
                  CoreText(
                    text,
                    weight: fontWeight ?? CoreTypography.bold,
                    color: foregroundColor ?? Colours.white,
                  ),
                  (!iconPositionFront)
                      ? SizedBox(width: context.widthScale * 10)
                      : const SizedBox.shrink(),
                  (!iconPositionFront) ? icon! : const SizedBox.shrink(),
                ],
              ),
      ),
    );
  }
}
