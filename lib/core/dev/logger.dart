import 'dart:developer';

import 'package:cpu_management/core/constants/images.dart';
import 'package:cpu_management/core/constants/routes.dart';
import 'package:cpu_management/screens/widget/one_c_common.dart';
import 'package:cpu_management/screens/widget/one_c_overlay.dart';


void logSuccess(String message, [bool showStackTrace = false]) {
  message = _truncateLongMessage(message);
  log(
    '\u001b[32m$message\u001b[0m',
    stackTrace: showStackTrace ? StackTrace.current : null,
  );
}

void logError(String message, [bool showPopup = false, String? title]) async {
  message = _truncateLongMessage(message);
  log('\u001b[31m$message\u001b[0m', stackTrace: StackTrace.current);
  var context = AppRoutes.navigatorKey.currentContext;
  if (context != null && showPopup) {
    OneCOverlay.hide(context);
    await showCommonErrorPopup(
      context: context,
      title: title ?? 'Error',
      message: message,
      assetImage: ConstantImages.chargingError,
      asScreen: true,
    );
  }
}

void logInfo(String message, [bool showStackTrace = false]) {
  message = _truncateLongMessage(message);
  log('\u001b[34m$message\u001b[0m');
}

void logWarning(String message, [bool showStackTrace = false]) {
  message = _truncateLongMessage(message);
  log(
    '\u001b[33m$message\u001b[0m',
    stackTrace: showStackTrace ? StackTrace.current : null,
  );
}

void logDebug(String message, [bool showStackTrace = false]) {
  message = _truncateLongMessage(message);
  log(
    '\u001b[35m$message\u001b[0m',
    stackTrace: showStackTrace ? StackTrace.current : null,
  );
}

String _truncateLongMessage(String message) {
  if (message.length > 1000) {
    return '${message.substring(0, 1000)}...';
  }
  return message;
}
