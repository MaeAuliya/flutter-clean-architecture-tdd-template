import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import '../res/colours.dart';
import '../res/texts.dart';
import '../res/typography.dart';
import '../shared/views/loading_view_dialog.dart';

/// {@template core_utils}
/// UI-focused helpers: snackbars, dialogs, etc.
///
/// Why no formatters here?
/// - Keeps Flutter-dependent logic separate from pure utilities.
/// - Clearer separation of presentation (UI) vs business logic.
/// {@endtemplate}
class CoreUtils {
  const CoreUtils._();

  /// {@template core_snackbar}
  /// Displays a styled snackbar with success or error state.
  /// {@endtemplate}
  static void showSnackBar({
    required BuildContext context,
    required String message,
    String title = Texts.stateSuccess,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            spacing: context.widthScale * 8,
            children: [
              Container(
                width: context.widthScale * 24,
                height: context.widthScale * 24,
                decoration: BoxDecoration(
                  color: Colours.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isError ? Icons.close_rounded : Icons.check_rounded,
                  color: isError ? Colours.errorColor : Colours.successColor,
                  size: context.widthScale * 16,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CoreText(
                      isError ? Texts.error : title,
                      color: Colours.white,
                      weight: FontWeight.bold,
                    ),
                    CoreText(message, color: Colours.white, maxLines: 10),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: isError ? Colours.errorColor : Colours.successColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  /// {@template core_loading_dialog}
  /// Shows a blocking loading dialog (non-dismissible).
  /// {@endtemplate}
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
        },
        child: const LoadingViewDialog(),
      ),
    );
  }
}
