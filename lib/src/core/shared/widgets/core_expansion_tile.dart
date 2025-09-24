import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../res/colours.dart';
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
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        side: BorderSide(color: Colours.gray400),
      ),
      collapsedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        side: BorderSide(color: Colours.gray400),
      ),
      onExpansionChanged: (value) {
        setState(() {
          _isExpanded = value;
        });
      },
      leading: (widget.leadingIcon != null)
          ? SvgPicture.asset(widget.leadingIcon!)
          : null,
      trailing: Icon(
        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: Colours.black,
      ),
      title: CoreText(widget.title, weight: CoreTypography.bold),
      children: widget.children,
    );
  }
}
