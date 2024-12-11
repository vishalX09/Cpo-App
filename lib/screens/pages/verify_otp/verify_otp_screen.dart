import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/routes.dart';
import 'package:cpu_management/core/dev/logger.dart';
import 'package:cpu_management/core/providers/home/home_provider.dart';
import 'package:cpu_management/core/utils/one_c_analytics.dart';
import 'package:cpu_management/core/utils/utils.dart';
import 'package:cpu_management/screens/pages/verify_otp/controller/verify_otp_controller.dart';
import 'package:cpu_management/screens/widget/one_c_button.dart';
import 'package:cpu_management/screens/widget/one_c_common.dart';
import 'package:cpu_management/screens/widget/one_c_onboarding_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:otp_text_field_v2/otp_field_style_v2.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({super.key, this.args});

  final Map<String, dynamic>? args;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  String? email = '';
  bool staySignedIn = false;
  final verifyOtpController =
      ChangeNotifierProvider<VerifyOtPController>((ref) {
    return VerifyOtPController();
  });
  late OTPInteractor _otpInteractor;
  late OTPTextEditController controller;
  OtpFieldControllerV2 controllerV2 = OtpFieldControllerV2();

  @override
  void initState() {
    super.initState();
    email = (widget.args as Map<String, dynamic>)['email'] as String?;
    staySignedIn =
        (widget.args as Map<String, dynamic>)['staySignedIn'] as bool;
    ref.read(verifyOtpController).init(email ?? '');
    setupAutoFill();
  }

  /// Setting up OTP Interactor for getting app signature for OTP autofill
  /// and setting code to [controllerV2] after [onCodeReceive]
  void setupAutoFill() {
    _otpInteractor = OTPInteractor();
    _otpInteractor.getAppSignature().then((value) {
      logSuccess('App Signature: $value');
    });
    controller = OTPTextEditController(
      codeLength: 4,
      onCodeReceive: (code) {
        logSuccess('Received code: $code');
        controllerV2.set(code.split(''));
      },
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{4})');
          OneCAnalytics().addToCurrentUserActionStack({
            'action': 'otp_autofill'.toUpperCase(),
            'otp': exp.stringMatch(code ?? '') ?? 'null',
          });
          return exp.stringMatch(code ?? '') ?? '';
        },
      );
  }

  void verifyOTP([String? otp]) async {
    var value = await ref.read(verifyOtpController).verifyOtp(
          ref,
          otp,
        );
    if (!mounted) return;
    if (value != null && value.data != null) {
      void sendAnalytics(String routeToPush) {
        OneCAnalytics().addToCurrentUserActionStack({
          'action': 'OTP_VERIFIED',
          'user_id': value.data?.id ?? 'null',
          'time': DateTime.now().hhmms,
          'wentTo': routeToPush,
        });
      }

      if (context.mounted) {
        ref.read(homeProvider.notifier).fetchProfile();
        final stationNames =
            await ref.read(homeProvider.notifier).fetchAndGetStationNames();

        Navigator.pushReplacementNamed(
          AppRoutes.navigatorKey.currentContext!,
          AppRoutes.main,
        );
      }
    } else {
      showErrorSnackbar(
          context: context,
          message: value?.message ?? AppLocalizations.of(context)!.invaildotp);
    }
  }

  @override
  Widget build(BuildContext context) {
    var verifyCtrlReader = ref.read(verifyOtpController);
    var verifyCtrlWatch = ref.watch(verifyOtpController);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const OneCOnboardingHeader(
              isVerifyScreen: true,
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              '${AppLocalizations.of(context)!.enterotpsentto} ${verifyCtrlReader.mail}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            OTPTextFieldV2(
              controller: controllerV2,
              width: 80.w,
              length: 4,
              fieldStyle: FieldStyle.box,
              outlineBorderRadius: 8,
              fieldWidth: 12.w,
              otpFieldStyle: OtpFieldStyle(
                borderColor: ConstantColors.black2,
                focusBorderColor: ConstantColors.primaryColor,
                backgroundColor: ConstantColors.white,
              ),
              style: const TextStyle(
                color: ConstantColors.labelBlack,
              ),
              keyboardType: TextInputType.number,
              contentPadding: const EdgeInsets.all(0),
              onCompleted: (String verificationCode) {
                verifyCtrlReader.changeOtp(verificationCode);
                ref.read(verifyOtpController).mail = email;
                verifyOTP(verificationCode);
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.didnotrecieveotp,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(width: 4),
                if (verifyCtrlWatch.time == verifyCtrlReader.constantTime)
                  GestureDetector(
                      onTap: () {
                        verifyCtrlReader.resendOtp();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.resendotp,
                        style: const TextStyle(
                          color: ConstantColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                if (verifyCtrlWatch.time != verifyCtrlReader.constantTime)
                  Text(
                    '${AppLocalizations.of(context)!.resendotpin00}${verifyCtrlWatch.time < 10 ? '0${verifyCtrlWatch.time}' : verifyCtrlWatch.time} sec',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Builder(builder: (context) {
                if (verifyCtrlWatch.isVerifying) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return OneCButton(
                  onPressed: () {
                    verifyOTP();
                  },
                  width: double.infinity,
                  label: AppLocalizations.of(context)!.verify.toUpperCase(),
                  labelColor: ConstantColors.white,
                  backgroundColor: ConstantColors.buttonBlack,
                );
              }),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: OneCButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                width: double.infinity,
                label: AppLocalizations.of(context)!.back.toUpperCase(),
                labelColor: ConstantColors.buttonBlack,
                backgroundColor: ConstantColors.white,
                borderSide: const BorderSide(
                  color: ConstantColors.buttonBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
