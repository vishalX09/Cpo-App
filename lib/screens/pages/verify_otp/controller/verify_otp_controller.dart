import 'dart:async';
import 'dart:convert';
import 'package:cpu_management/core/constants/routes.dart';
import 'package:cpu_management/core/models/user/user.dart';
import 'package:cpu_management/core/providers/global_provider.dart';
import 'package:cpu_management/core/utils/one_c_analytics.dart';
import 'package:cpu_management/core/utils/utils.dart';
import 'package:cpu_management/screens/pages/verify_otp/repository/verify_otp_repository.dart';
import 'package:cpu_management/screens/widget/one_c_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyOtPController extends ChangeNotifier {
  String? mail;
  int time = 15;
  int constantTime = 15;
  String currentOtp = '';
  VerifyOtpRepository verifyOtpRepository = VerifyOtpRepository();
  bool isVerifying = false;

  init(String mail) async {
    mail = mail;
    startTimer();
  }

  Future<bool> sendOtpVerification() async {
    var res =
        await verifyOtpRepository.sendOtp(mail: mail!, staySignedIn: true);
    if (res) {
      showSuccessSnackbar(
        context: AppRoutes.navigatorKey.currentContext!,
        message: 'Otp sent successfully',
      );
      OneCAnalytics().addToCurrentUserActionStack({
        'action': 'OTP_SENT',
        'mail': mail,
        'api_response': res,
        'time': DateTime.now().hhmms,
      });
      return true;
    }
    return false;
  }

  Future<User?> verifyOtp(
    WidgetRef ref, [
    String? otp,
  ]) async {
    isVerifying = true;
    notifyListeners();
    var res = await verifyOtpRepository.verifyOtp(
      otp: currentOtp,
      mail: mail!,
      ref: ref,
    );
    isVerifying = false;
    notifyListeners();
    if (res != null && res.data != null) {
      ref.read(authProvider).setUser(jsonEncode(res.toJson()));
      OneCAnalytics().addToCurrentUserActionStack({
        'action': 'OTP_VERIFY_SUCCESS',
        'mail': mail,
        'api_response': res.toJson(),
        'otp_entered': currentOtp,
        'time': DateTime.now().hhmms,
      });
      return res;
    }
    OneCAnalytics().addToCurrentUserActionStack({
      'action': 'OTP_VERIFY_FAILED',
      'mail': mail,
      'api_response': res,
      'otp_entered': currentOtp,
      'time': DateTime.now().hhmms,
    });
    return res;
  }

  void changeOtp(String otp) {
    currentOtp = otp;
  }

  void startTimer() {
    time--;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time == 0) {
        time = constantTime;
        notifyListeners();
        timer.cancel();
      } else {
        time--;
        notifyListeners();
      }
    });
  }

  void resendOtp() {
    OneCAnalytics().addToCurrentUserActionStack({
      'action': 'RESEND_OTP',
      'mail': mail ?? 'null',
    });
    sendOtpVerification();
    time = constantTime;
    notifyListeners();
    startTimer();
  }
}
