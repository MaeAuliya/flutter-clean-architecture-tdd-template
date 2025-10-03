import 'package:intl/intl.dart';

/// {@template format_utils}
/// Pure number & currency formatting helpers (no Flutter dependency).
///
/// Why separate this from [CoreUtils]?
/// - Single Responsibility: focuses only on formatting logic.
/// - Easier unit testing (no Flutter bindings required).
/// - Reusable across layers (domain/data) without importing Flutter.
///
/// ⚠️ All functions here are **pure** (input → output),
/// safe to use anywhere.
/// {@endtemplate}
class FormatUtils {
  const FormatUtils._();

  /// {@template format_currency}
  /// Cleans non-digit characters and formats the result into a currency string.
  ///
  /// Example:
  /// ```dart
  /// FormatUtils.formatCurrency("2000000"); // Rp 2.000.000
  /// FormatUtils.formatCurrency(
  ///   "1000",
  ///   symbol: "\$",
  ///   locale: "en_US",
  ///   decimalDigits: 2,
  /// ); // $1,000.00
  /// ```
  /// {@endtemplate}
  static String formatCurrency(
    String amountString, {
    String locale = 'id_ID',
    String symbol = 'Rp ',
    int decimalDigits = 0,
  }) {
    final number =
        int.tryParse(amountString.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );

    return formatter.format(number);
  }

  /// {@template format_number}
  /// Formats any numeric value into a simplified string.
  ///
  /// Rules:
  /// - Negative values → `"0"`.
  /// - Whole numbers → no decimals.
  /// - Decimal numbers → up to 2 decimals.
  ///
  /// Example:
  /// ```dart
  /// FormatUtils.formatNumber(10);    // "10"
  /// FormatUtils.formatNumber(10.5);  // "10.50"
  /// FormatUtils.formatNumber(-5);    // "0"
  /// ```
  /// {@endtemplate}
  static String formatNumber(num value) {
    if (value < 0) return '0';
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
  }
}
