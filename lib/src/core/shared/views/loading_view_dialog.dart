import 'package:flutter/material.dart';

import '../../res/colours.dart';

class LoadingViewDialog extends StatelessWidget {
  const LoadingViewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colours.primaryBlue,
          ),
        ),
      ),
    );
  }
}
