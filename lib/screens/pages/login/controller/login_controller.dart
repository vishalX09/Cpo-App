import 'package:cpu_management/core/constants/routes.dart';
import 'package:cpu_management/core/utils/one_c_analytics.dart';
import 'package:cpu_management/core/utils/utils.dart';
import 'package:cpu_management/screens/pages/verify_otp/repository/verify_otp_repository.dart';
import 'package:cpu_management/screens/widget/one_c_common.dart';
import 'package:cpu_management/screens/widget/one_c_overlay.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  TextEditingController mailController = TextEditingController(text: '');
  bool staySignedIn = false;
  VerifyOtpRepository verifyOtpRepository = VerifyOtpRepository();

  Future<bool> sendToVerifyOtp(BuildContext context) async {
    if (mailController.text.isEmpty) {
      showErrorSnackbar(
        context: context,
        message: "Please enter a valid email here",
      );
      return false;
    }
    OneCOverlay.show(context);
    OneCAnalytics().addToCurrentUserActionStack({
      'action': 'GET_OTP',
      'email': mailController.text,
      'wentTo': AppRoutes.verifyOtp,
      'time': DateTime.now().hhmms,
    });

    var res = await sendOtpVerification();
    OneCOverlay.hide(context);
    if (!res) {
      showErrorSnackbar(
          context: AppRoutes.navigatorKey.currentContext!,
          message: "Owner dont own any station");
      return false;
    }
    Navigator.pushNamed(context, AppRoutes.verifyOtp, arguments: {
      'email': mailController.text,
      'staySignedIn': staySignedIn,
    });
    return true;
  }

  Future<bool> sendOtpVerification() async {
    var res = await verifyOtpRepository.sendOtp(
        mail: mailController.text, staySignedIn: staySignedIn);
    if (res) {
      showSuccessSnackbar(
        context: AppRoutes.navigatorKey.currentContext!,
        message: 'Otp sent successfully',
      );
      OneCAnalytics().addToCurrentUserActionStack({
        'action': 'OTP_SENT',
        'mail': mailController.text,
        'api_response': res,
        'time': DateTime.now().hhmms,
      });
      return true;
    }
    return false;
  }

  void staySignedForSeveneDays(bool value) {
    staySignedIn = value;
    notifyListeners();
  }
}
