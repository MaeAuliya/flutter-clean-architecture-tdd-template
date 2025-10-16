import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/context_extension.dart';

class SocialMediaIconButton extends StatelessWidget {
  final String image;
  final Color backgroundColor;
  final VoidCallback onTap;

  const SocialMediaIconButton({
    super.key,
    required this.image,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: backgroundColor,
      ),
      child: SvgPicture.asset(
        image,
        width: context.widthScale * 32,
        height: context.widthScale * 32,
      ),
    );
  }
}
