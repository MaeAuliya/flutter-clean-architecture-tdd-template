import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../extensions/context_extension.dart';
import '../../res/typography.dart';

class CoreExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final String? leadingIcon;

  const CoreExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.leadingIcon,
  });

  @override
  State<CoreExpansionTile> createState() => _CoreExpansionTileState();
}

class _CoreExpansionTileState extends State<CoreExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      side: BorderSide(color: context.colorScheme.outline),
    );

    return ExpansionTile(
      shape: shape,
      collapsedShape: shape,
      onExpansionChanged: (value) => setState(() => _isExpanded = value),
      leading: widget.leadingIcon == null
          ? null
          : SvgPicture.asset(widget.leadingIcon!),
      trailing: Icon(
        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: context.colorScheme.onSurface,
      ),
      title: CoreText(widget.title, weight: CoreTypography.bold),
      children: widget.children,
    );
  }
}
