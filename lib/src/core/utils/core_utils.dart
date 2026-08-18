import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
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
    final scheme = context.colorScheme;
    final background = isError ? scheme.error : scheme.tertiary;
    final foreground = isError ? scheme.onError : scheme.onTertiary;

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
                  color: foreground,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isError ? Icons.close_rounded : Icons.check_rounded,
                  color: background,
                  size: context.widthScale * 16,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CoreText(
                      isError ? Texts.error : title,
                      color: foreground,
                      weight: FontWeight.bold,
                    ),
                    CoreText(message, color: foreground, maxLines: 10),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: background,
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
