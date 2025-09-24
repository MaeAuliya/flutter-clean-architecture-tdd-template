import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/colours.dart';
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
    this.statusBarIconColor = Brightness.dark,
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
  final Brightness statusBarIconColor;
  final bool isOnlyNeedStatusBar;
  final Color? statusBarColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? Colors.transparent,
        statusBarIconBrightness: statusBarIconColor,
        statusBarBrightness: (statusBarIconColor == Brightness.dark)
            ? Brightness.light
            : Brightness.dark,
      ),
      actions: [
        child != null
            ? Padding(padding: const EdgeInsets.only(right: 20), child: child)
            : const SizedBox.shrink(),
      ],
      toolbarHeight: 70,
      leadingWidth: 70,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      backgroundColor:
          backgroundColor ?? (title == "" ? Colors.transparent : Colours.white),
      foregroundColor: foregroundColor ?? Colours.black,
      elevation: 0,
      leading: isBackButton == true
          ? IconButton(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 1),
              icon:
                  icon ??
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    color: foregroundColor ?? Colours.black,
                    size: 20,
                  ),
              onPressed:
                  onPressed ??
                  () {
                    Navigator.pop(context);
                  },
            )
          : const SizedBox.shrink(),
      title: CoreText(
        title,
        weight: CoreTypography.bold,
        size: size ?? 20,
        color: foregroundColor ?? Colours.black,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(isOnlyNeedStatusBar ? 0 : 64);
}
