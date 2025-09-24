import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import '../../res/colours.dart';
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
    if (isUseRefresh) {
      return Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (_, __) => Container(
            margin: EdgeInsets.only(bottom: context.height * 0.15),
            child: Column(
              spacing: context.heightScale * 8,
              children: [
                Center(
                  child: Image.asset(
                    MediaRes.emptyStateVector,
                    width: context.width * 0.5,
                    height: context.width * 0.5,
                  ),
                ),
                Column(
                  spacing: context.heightScale * 4,
                  children: [
                    CoreText(
                      title,
                      weight: CoreTypography.bold,
                      size: 16,
                      color: Colours.primaryBlue,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: descriptionWidth ?? context.width * 0.575,
                      child: CoreText(
                        description,
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
      );
    }
    return Container(
      margin: EdgeInsets.only(bottom: context.height * 0.15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: context.heightScale * 8,
        children: [
          Center(
            child: Image.asset(
              MediaRes.emptyStateVector,
              width: context.width * 0.5,
              height: context.width * 0.5,
            ),
          ),
          Column(
            spacing: context.heightScale * 4,
            children: [
              CoreText(
                title,
                weight: CoreTypography.bold,
                size: 16,
                color: Colours.primaryBlue,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: descriptionWidth ?? context.width * 0.575,
                child: CoreText(
                  description,
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
