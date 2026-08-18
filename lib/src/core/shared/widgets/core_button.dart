import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import '../../res/fonts.dart';
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
    final scheme = context.colorScheme;
    final foreground = isDisable
        ? scheme.onSurfaceVariant
        : foregroundColor ?? scheme.onPrimary;

    return IgnorePointer(
      ignoring: isDisable,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(minimumSize * context.heightScale),
          shape: RoundedRectangleBorder(
            side: borderColor == null
                ? BorderSide.none
                : BorderSide(color: borderColor!),
            borderRadius: BorderRadius.circular(radius ?? 4),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 12,
            vertical: verticalPadding ?? 8,
          ),
          backgroundColor: isDisable
              ? scheme.surfaceContainerHighest
              : backgroundColor ?? scheme.primary,
          foregroundColor: foreground,
          shadowColor: scheme.shadow.withAlpha(5),
        ),
        onPressed: onPressed,
        child: icon == null
            ? CoreText(
                text,
                weight: fontWeight ?? CoreTypography.bold,
                size: fontSize,
                family: fontFamily ?? Fonts.roboto,
                color: foreground,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconPositionFront) icon!,
                  if (iconPositionFront)
                    SizedBox(width: context.widthScale * 10),
                  CoreText(
                    text,
                    weight: fontWeight ?? CoreTypography.bold,
                    size: fontSize,
                    family: fontFamily ?? Fonts.roboto,
                    color: foreground,
                  ),
                  if (!iconPositionFront)
                    SizedBox(width: context.widthScale * 10),
                  if (!iconPositionFront) icon!,
                ],
              ),
      ),
    );
  }
}
