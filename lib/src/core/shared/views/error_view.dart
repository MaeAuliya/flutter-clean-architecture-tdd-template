import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import '../../res/colours.dart';
import '../../res/media_res.dart';
import '../../res/typography.dart';

class ErrorView extends StatelessWidget {
  final String? title;
  final String? description;
  final double? descriptionWidth;
  final EdgeInsets? padding;
  final Future<void> Function()? onRefresh;
  final bool isUseButton;
  final bool isUseOutsideRefresh;

  const ErrorView({
    super.key,
    this.onRefresh,
    this.title,
    this.description,
    this.descriptionWidth,
    this.padding,
    this.isUseButton = false,
    this.isUseOutsideRefresh = false,
  });

  @override
  Widget build(BuildContext context) {
    if (onRefresh != null && isUseButton) {
      return Container(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: context.heightScale * 8,
          children: [
            Center(
              child: Image.asset(
                MediaRes.errorStateVector,
                width: context.widthScale * 200,
                height: context.widthScale * 200,
              ),
            ),
            Column(
              spacing: context.heightScale * 4,
              children: [
                CoreText(
                  title ?? 'Something Went Wrong',
                  weight: CoreTypography.bold,
                  size: 16,
                  color: Colours.primaryBlue,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: descriptionWidth ?? context.width * 0.65,
                  child: CoreText(
                    description ??
                        'We apologize for the inconvenience. \nPlease refresh the page or try again later..',
                    color: Colours.gray400,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: onRefresh,
              child: const CoreText(
                'Refresh',
                color: Colours.primaryBlue,
                textAlign: TextAlign.center,
                weight: CoreTypography.semiBold,
                size: 14,
              ),
            ),
          ],
        ),
      );
    } else if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: Center(
          child: ListView.builder(
            padding: padding,
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (_, __) => Container(
              margin: EdgeInsets.only(bottom: context.height * 0.15),
              child: Column(
                spacing: context.heightScale * 8,
                children: [
                  Center(
                    child: Image.asset(
                      MediaRes.errorStateVector,
                      width: context.widthScale * 200,
                      height: context.widthScale * 200,
                    ),
                  ),
                  Column(
                    spacing: context.heightScale * 4,
                    children: [
                      CoreText(
                        title ?? 'Something Went Wrong',
                        weight: CoreTypography.bold,
                        size: 16,
                        color: Colours.primaryBlue,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: descriptionWidth ?? context.width * 0.65,
                        child: CoreText(
                          description ??
                              'We apologize for the inconvenience. \nPlease refresh the page or try again later..',
                          color: Colours.gray400,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (isUseOutsideRefresh) {
      return Center(
        child: ListView.builder(
          padding: padding,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (_, __) => Column(
            spacing: context.heightScale * 8,
            children: [
              Center(
                child: Image.asset(
                  MediaRes.errorStateVector,
                  width: context.widthScale * 200,
                  height: context.widthScale * 200,
                ),
              ),
              Column(
                spacing: context.heightScale * 4,
                children: [
                  CoreText(
                    title ?? 'Something Went Wrong',
                    weight: CoreTypography.bold,
                    size: 16,
                    color: Colours.primaryBlue,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: descriptionWidth ?? context.width * 0.65,
                    child: CoreText(
                      description ??
                          'We apologize for the inconvenience. \nPlease refresh the page or try again later..',
                      color: Colours.gray400,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        padding: padding,
        margin: EdgeInsets.only(bottom: context.height * 0.15),
        child: Column(
          spacing: context.heightScale * 8,
          children: [
            Center(
              child: Image.asset(
                MediaRes.errorStateVector,
                width: context.widthScale * 200,
                height: context.widthScale * 200,
              ),
            ),
            Column(
              spacing: context.heightScale * 4,
              children: [
                CoreTypography.coreText(
                  text: title ?? 'Something Went Wrong',
                  fontWeight: CoreTypography.bold,
                  fontSize: 16,
                  color: Colours.primaryBlue,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: descriptionWidth ?? context.width * 0.6,
                  child: CoreText(
                    description ??
                        'We apologize for the inconvenience. \nPlease refresh the page or try again later..',
                    color: Colours.gray400,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
