import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

abstract interface class AppLogger {
  void debug(String message, {Map<String, Object?> context = const {}});

  void nonFatal(
    Object error,
    StackTrace stack, {
    required String reason,
    Map<String, Object?> context = const {},
  });

  void fatal(Object error, StackTrace stack, {required String reason});
}

final class DebugAppLogger implements AppLogger {
  const DebugAppLogger();

  @override
  void debug(String message, {Map<String, Object?> context = const {}}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'app.debug',
        error: context.isEmpty ? null : context,
      );
    }
  }

  @override
  void nonFatal(
    Object error,
    StackTrace stack, {
    required String reason,
    Map<String, Object?> context = const {},
  }) {
    developer.log(
      reason,
      name: 'app.non_fatal',
      error: context.isEmpty ? error : (error: error, context: context),
      stackTrace: stack,
      level: 900,
    );
  }

  @override
  void fatal(Object error, StackTrace stack, {required String reason}) {
    developer.log(
      reason,
      name: 'app.fatal',
      error: error,
      stackTrace: stack,
      level: 1200,
    );
  }
}
