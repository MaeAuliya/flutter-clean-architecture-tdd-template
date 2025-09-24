import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../../features/authentication/presentation/screens/sign_in_screen.dart';
import '../../features/authentication/presentation/screens/sign_in_with_pin_screen.dart';
import '../extensions/context_extension.dart';
import '../res/colours.dart';
import '../res/texts.dart';
import '../res/typography.dart';
import '../services/date_time_formatter.dart';
import '../shared/views/loading_view_dialog.dart';

class CoreUtils {
  const CoreUtils._();

  static String? passwordValidator(String? input) {
    if (input == null || input.isEmpty) {
      return Texts.emptyValidator;
    } else if (input.length < 8) {
      return Texts.passwordEightCharValidator;
    }
    return null;
  }

  static String? phoneNumberValidator(String? input) {
    if (input == null || input.isEmpty) {
      return Texts.emptyValidator;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(input)) {
      return 'Phone number must contain only digits.';
    } else if (input.length < 10) {
      return 'Phone number must be at least 10 digits.';
    } else if (input.length > 15) {
      return 'Phone number must be no more than 15 digits.';
    }
    return null;
  }

  static String? emailValidator(String? input) {
    if (input == null || input.isEmpty) {
      return Texts.emptyValidator;
    } else if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
      r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    ).hasMatch(input)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? input, String password) {
    if (input == null || input.isEmpty) {
      return Texts.emptyValidator;
    } else if (input != password) {
      return Texts.passwordValueValidator;
    }
    return null;
  }

  static String? drivingLicenseValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'SIM number cannot be empty';
    } else if (!RegExp(r'^[0-9-]+$').hasMatch(input)) {
      return 'SIM number can only contain digits and "-"';
    }

    final digitCount = input.replaceAll('-', '').length;

    if (digitCount < 8 || digitCount > 20) {
      return 'SIM number must contain 8-20 digits';
    }

    return null;
  }

  static String? licenseExpiredValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'License expired date cannot be empty';
    }

    final dateInput = DateTimeFormatter.formatStringDateToDateTime(
      input,
      format: CoreDateFormat.dMMMMyyyy,
    );

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final expiredDate = DateTime(
      dateInput.year,
      dateInput.month,
      dateInput.day,
    );

    if (expiredDate.isBefore(today)) {
      return 'Your license has already expired.';
    }

    final daysLeft = expiredDate.difference(today).inDays;

    if (daysLeft == 0) {
      return 'Your license will expire today!';
    } else if (daysLeft <= 30) {
      return 'Your license will expire in $daysLeft day(s). Please renew soon.';
    }

    return null;
  }

  static String? formatTimeReservation(TimeOfDay? time) {
    if (time == null) {
      return null;
    }

    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static void showSnackBar({
    required BuildContext context,
    required String message,
    String title = Texts.success,
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
                  color: isError ? Colours.errorColor : Colours.successSnackBar,
                  size: context.widthScale * 16,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CoreTypography.coreText(
                      text: isError ? Texts.error : title,
                      color: Colours.white,
                      fontWeight: FontWeight.bold,
                    ),
                    CoreTypography.coreText(
                      text: message,
                      color: Colours.white,
                      maxLine: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: isError
              ? Colours.errorColor
              : Colours.successSnackBar,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
          // showCloseIcon: true,
          // closeIconColor: Colours.white,
        ),
      );
  }

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

  static void sessionExpiredHandler(BuildContext context) {
    showSnackBar(
      context: context,
      message: Texts.sessionExpired,
      isError: true,
    );
    Navigator.pushNamed(context, SignInWithPinScreen.routeName);
  }

  static void sessionExpiredWithNoTokenHandler(BuildContext context) {
    showSnackBar(
      context: context,
      message: Texts.sessionExpired,
      isError: true,
    );
    Navigator.pushNamed(context, SignInScreen.routeName);
  }

  static String formatRupiah(double amount) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 2,
    );
    return currencyFormatter.format(amount);
  }

  static String formatToCurrency(String amountString) {
    final number =
        int.tryParse(amountString.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  static double calculateDistanceAndCameraZoom({
    required double latA,
    required double longA,
    required double latB,
    required double longB,
  }) {
    // calculate distance with haversine formula
    const double R = 6371;
    double dLat = _degToRad(latB - latA);
    double dLng = _degToRad(longB - longA);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(latA)) *
            cos(_degToRad(latB)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    /// Distance Value
    double distance = R * c;

    // Zoom Value
    if (distance < 10) return 15; // Zoom very close
    if (distance < 50) return 12; // Zoom on city
    if (distance < 200) return 10; // Zoom between city
    if (distance < 1000) return 7; // Zoom between regions
    if (distance < 5000) return 4; // Zoom between countries
    return 2; // full earth zoom
  }

  static double _degToRad(double deg) {
    return deg * pi / 180;
  }

  static String formatDouble(num value) {
    if (value < 0) {
      return 0.toString();
    }
    return value % 1 == 0
        ? value.toInt().toString()
        : value.toDouble().toStringAsFixed(2);
  }

  static int differenceMinutesDurationReservation({
    required DateTime startTime,
    required DateTime endTime,
  }) {
    return endTime.difference(startTime).inMinutes;
  }

  static Future<Uint8List> renderWidgetToImage({required GlobalKey key}) async {
    final repaintBoundary = key;

    final boundary =
        repaintBoundary.currentContext!.findRenderObject()
            as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static String getOrderTransactionTotalReceipt({
    required double gross,
    required double voucherValue,
    required double? taxRate,
  }) {
    double finalAmount = 0;
    if (taxRate != null && voucherValue > 0) {
      final temp = gross - voucherValue;
      finalAmount = temp + (temp * taxRate / 100);
    } else if (voucherValue <= 0 && taxRate != null) {
      finalAmount = gross + (gross * taxRate / 100);
    } else if (voucherValue > 0 && taxRate == null) {
      finalAmount = gross - voucherValue;
    } else {
      finalAmount = gross;
    }

    return formatRupiah((finalAmount < 0) ? 0 : finalAmount);
  }

  static DateTime roundUpToNearestHalfHour(DateTime input) {
    int minute = input.minute;
    int addMinutes;

    if (minute == 0 || minute <= 30) {
      addMinutes = minute == 0 ? 0 : (30 - minute);
    } else {
      addMinutes = 60 - minute;
    }

    return input
        .add(Duration(minutes: addMinutes))
        .copyWith(second: 0, millisecond: 0, microsecond: 0);
  }

  static String simplifyDurationDoubleText(double duration) {
    if (duration == duration.roundToDouble()) {
      return duration.toInt().toString();
    } else {
      return duration.toString();
    }
  }

  static String getCancelReason(
    int currentCancelOption, {
    required String customReason,
  }) {
    switch (currentCancelOption) {
      case 1:
        return 'I no longer need a vehicle';
      case 2:
        return 'My travel plans have changed';
      case 3:
        return 'I booked the wrong date/time';
      case 4:
        return 'I selected the wrong pickup location';
      case 5:
        return customReason;
      default:
        return 'I no longer need a vehicle';
    }
  }
}
