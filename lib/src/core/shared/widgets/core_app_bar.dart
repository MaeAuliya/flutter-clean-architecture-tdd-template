import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/typography.dart';

class CoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CoreAppBar({
    super.key,
    required this.title,
    this.icon,
    this.child,
    this.size = 20,
    this.isBackButton = true,
    this.centerTitle = true,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.statusBarIconColor,
    this.isOnlyNeedStatusBar = false,
    this.statusBarColor,
  });

  final Icon? icon;
  final String title;
  final Widget? child;
  final double? size;
  final bool? isBackButton;
  final bool centerTitle;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Brightness? statusBarIconColor;
  final bool isOnlyNeedStatusBar;
  final Color? statusBarColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = foregroundColor ?? theme.colorScheme.onSurface;
    final overlayBrightness =
        statusBarIconColor ??
        (theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);

    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? Colors.transparent,
        statusBarIconBrightness: overlayBrightness,
        statusBarBrightness: overlayBrightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      actions: [
        if (child != null)
          Padding(padding: const EdgeInsets.only(right: 20), child: child!),
      ],
      toolbarHeight: 70,
      leadingWidth: 70,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      backgroundColor:
          backgroundColor ??
          (title.isEmpty ? Colors.transparent : theme.colorScheme.surface),
      foregroundColor: foreground,
      elevation: 0,
      leading: isBackButton == true
          ? IconButton(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 1),
              icon:
                  icon ??
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    color: foreground,
                    size: 20,
                  ),
              onPressed: onPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: CoreText(
        title,
        weight: CoreTypography.bold,
        size: size ?? 20,
        color: foreground,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(isOnlyNeedStatusBar ? 0 : 64);
}
