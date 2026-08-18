import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../extensions/context_extension.dart';
import '../../res/media_res.dart';
import '../../res/typography.dart';

class EmptyView extends StatelessWidget {
  final String title;
  final String description;
  final bool isUseRefresh;
  final double? descriptionWidth;

  const EmptyView({
    super.key,
    required this.title,
    required this.description,
    this.isUseRefresh = true,
    this.descriptionWidth,
  });

  @override
  Widget build(BuildContext context) {
    final body = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: context.heightScale * 8,
      children: [
        SvgPicture.asset(
          MediaRes.emptyStateVector,
          width: context.width * 0.5,
          height: context.width * 0.5,
        ),
        CoreText(
          title,
          weight: CoreTypography.bold,
          size: 16,
          color: context.colorScheme.primary,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: descriptionWidth ?? context.width * 0.575,
          child: CoreText(
            description,
            color: context.colorScheme.onSurfaceVariant,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ),
      ],
    );

    if (!isUseRefresh) {
      return Container(
        margin: EdgeInsets.only(bottom: context.height * 0.15),
        child: body,
      );
    }

    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(height: context.height * 0.15),
        body,
      ],
    );
  }
}
