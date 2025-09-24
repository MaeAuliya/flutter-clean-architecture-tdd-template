import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import '../../res/colours.dart';
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
    this.actionColor = Colours.darkBlue,
  });

  final String title;
  final String description;
  final bool isHaveActionButton;
  final String? actionButtonTitle;
  final VoidCallback? actionButtonOnTap;
  final String? cancelButtonTitle;
  final bool isReverse;
  final Color actionColor;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.pop(context);
      },
      child: Dialog(
        surfaceTintColor: Colours.white,
        insetPadding: EdgeInsets.all(context.widthScale * 12),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: context.heightScale * 32,
            horizontal: context.widthScale * 24,
          ),
          decoration: BoxDecoration(
            color: Colours.white,
            borderRadius: BorderRadius.circular(20),
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
                    color: Colours.black,
                    maxLines: 2,
                  ),
                  CoreText(
                    description,
                    textAlign: TextAlign.center,
                    weight: CoreTypography.regular,
                    color: Colours.gray400,
                    maxLines: 2,
                  ),
                ],
              ),
              isHaveActionButton
                  ? isReverse
                        ? Row(
                            spacing: context.widthScale * 4,
                            children: [
                              Expanded(
                                child: CoreButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  backgroundColor: Colours.white,
                                  foregroundColor: Colours.darkBlue,
                                  borderColor: Colours.darkBlue,
                                  text: cancelButtonTitle ?? 'Cancel',
                                ),
                              ),
                              Expanded(
                                child: CoreButton(
                                  onPressed: actionButtonOnTap ?? () {},
                                  text: actionButtonTitle ?? '',
                                  backgroundColor: actionColor,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            spacing: context.widthScale * 4,
                            children: [
                              Expanded(
                                child: CoreButton(
                                  onPressed: actionButtonOnTap ?? () {},
                                  text: actionButtonTitle ?? '',
                                  backgroundColor: actionColor,
                                ),
                              ),
                              Expanded(
                                child: CoreButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  backgroundColor: Colours.white,
                                  foregroundColor: Colours.darkBlue,
                                  borderColor: Colours.darkBlue,
                                  text: cancelButtonTitle ?? 'Cancel',
                                ),
                              ),
                            ],
                          )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
