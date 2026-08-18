import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final bool isTransparent;
  final Color? color;

  const LoadingView({
    super.key,
    this.isTransparent = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: isTransparent
          ? scheme.scrim.withValues(alpha: 0.54)
          : color ?? scheme.surface,
      child: Center(
        child: CircularProgressIndicator(color: scheme.primary),
      ),
    );
  }
}
