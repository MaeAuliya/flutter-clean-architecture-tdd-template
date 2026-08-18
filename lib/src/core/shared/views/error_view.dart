import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../extensions/context_extension.dart';
import '../../res/media_res.dart';
import '../../res/typography.dart';

enum ErrorViewVariant { plain, button, pullToRefresh, outsideRefresh }

class ErrorView extends StatelessWidget {
  final String? title;
  final String? description;
  final double? descriptionWidth;
  final EdgeInsets? padding;
  final RefreshCallback? onRefresh;
  final ErrorViewVariant variant;

  const ErrorView({
    super.key,
    this.onRefresh,
    this.title,
    this.description,
    this.descriptionWidth,
    this.padding,
    this.variant = ErrorViewVariant.plain,
  }) : assert(
         (variant != ErrorViewVariant.button &&
                 variant != ErrorViewVariant.pullToRefresh) ||
             onRefresh != null,
         'Button and pull-to-refresh variants require onRefresh.',
       );

  @override
  Widget build(BuildContext context) {
    final body = _ErrorBody(
      title: title,
      description: description,
      descriptionWidth: descriptionWidth,
      showButton: variant == ErrorViewVariant.button,
      onRefresh: onRefresh,
    );

    return switch (variant) {
      ErrorViewVariant.plain => Container(
        padding: padding,
        margin: EdgeInsets.only(bottom: context.height * 0.15),
        child: body,
      ),
      ErrorViewVariant.button => Padding(
        padding: padding ?? EdgeInsets.zero,
        child: body,
      ),
      ErrorViewVariant.pullToRefresh => RefreshIndicator(
        onRefresh: onRefresh!,
        child: ListView(
          padding: padding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: context.height * 0.15),
            body,
          ],
        ),
      ),
      ErrorViewVariant.outsideRefresh => ListView(
        padding: padding,
        shrinkWrap: true,
        children: [body],
      ),
    };
  }
}

class _ErrorBody extends StatelessWidget {
  final String? title;
  final String? description;
  final double? descriptionWidth;
  final bool showButton;
  final RefreshCallback? onRefresh;

  const _ErrorBody({
    this.title,
    this.description,
    this.descriptionWidth,
    required this.showButton,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: context.heightScale * 8,
      children: [
        SvgPicture.asset(
          MediaRes.errorStateVector,
          width: context.widthScale * 200,
          height: context.widthScale * 200,
        ),
        CoreText(
          title ?? 'Something Went Wrong',
          weight: CoreTypography.bold,
          size: 16,
          color: context.colorScheme.primary,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: descriptionWidth ?? context.width * 0.65,
          child: CoreText(
            description ??
                'We apologize for the inconvenience.\nPlease refresh the page or try again later.',
            color: context.colorScheme.onSurfaceVariant,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ),
        if (showButton)
          TextButton(
            onPressed: onRefresh,
            child: const Text('Refresh'),
          ),
      ],
    );
  }
}
