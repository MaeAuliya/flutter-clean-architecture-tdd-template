import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import '../../res/typography.dart';
import 'core_button.dart';

class CoreDialog extends StatelessWidget {
  const CoreDialog({
    super.key,
    required this.title,
    required this.description,
    this.isHaveActionButton = false,
    this.actionButtonTitle,
    this.actionButtonOnTap,
    this.cancelButtonTitle,
    this.isReverse = false,
    this.actionColor,
  });

  final String title;
  final String description;
  final bool isHaveActionButton;
  final String? actionButtonTitle;
  final VoidCallback? actionButtonOnTap;
  final String? cancelButtonTitle;
  final bool isReverse;
  final Color? actionColor;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final cancel = CoreButton(
      onPressed: () => Navigator.pop(context),
      backgroundColor: scheme.surface,
      foregroundColor: scheme.primary,
      borderColor: scheme.primary,
      text: cancelButtonTitle ?? 'Cancel',
    );
    final action = CoreButton(
      onPressed: actionButtonOnTap ?? () {},
      text: actionButtonTitle ?? '',
      backgroundColor: actionColor ?? scheme.primary,
    );

    return PopScope(
      child: Dialog(
        surfaceTintColor: scheme.surface,
        insetPadding: EdgeInsets.all(context.widthScale * 12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.heightScale * 32,
            horizontal: context.widthScale * 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: context.heightScale * 24,
            children: [
              Column(
                spacing: context.heightScale * 6,
                children: [
                  CoreText(
                    title,
                    textAlign: TextAlign.center,
                    weight: CoreTypography.bold,
                    size: 16,
                    color: scheme.onSurface,
                    maxLines: 2,
                  ),
                  CoreText(
                    description,
                    textAlign: TextAlign.center,
                    color: scheme.onSurfaceVariant,
                    maxLines: 2,
                  ),
                ],
              ),
              if (isHaveActionButton)
                Row(
                  spacing: context.widthScale * 4,
                  children: isReverse
                      ? [Expanded(child: cancel), Expanded(child: action)]
                      : [Expanded(child: action), Expanded(child: cancel)],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
