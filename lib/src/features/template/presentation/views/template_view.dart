import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/res/colours.dart';
import '../../../../core/res/media_res.dart';
import '../../../../core/res/texts.dart';
import '../../../../core/res/typography.dart';
import '../bloc/template_bloc.dart';
import '../providers/template_provider.dart';
import '../widgets/social_media_icon.dart';

class TemplateView extends StatelessWidget {
  const TemplateView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.all(
          context.widthScale * 32,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                spacing: context.heightScale * 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CoreText(
                    Texts.templateTitle,
                    color: Colours.primaryBlue,
                    size: 16,
                    maxLines: 2,
                    weight: CoreTypography.semiBold,
                    textAlign: TextAlign.center,
                  ),
                  const CoreText(
                    Texts.templateDesc,
                    size: 14,
                    maxLines: 10,
                    textAlign: TextAlign.center,
                  ),
                  const CoreText(
                    Texts.templateDesc2,
                    color: Colours.gray300,
                    size: 12,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              spacing: context.heightScale * 12,
              children: [
                Consumer<TemplateProvider>(
                  builder: (_, provider, __) {
                    if (provider.templateVersion == null) {
                      return const SizedBox.shrink();
                    }
                    return CoreText(
                      'Current Version : ${provider.templateVersion!.version} +${provider.templateVersion!.buildNumber}',
                      color: Colours.primaryBlue,
                      size: 14,
                      weight: CoreTypography.semiBold,
                    );
                  },
                ),
                const CoreText(
                  Texts.visitMe,
                  size: 12,
                ),
                SocialMediaIconButton(
                  image: MediaRes.githubIcon,
                  backgroundColor: Colours.primaryBlue,
                  onTap: () {
                    context.templateBloc.add(const OpenGithubUrlEvent());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
