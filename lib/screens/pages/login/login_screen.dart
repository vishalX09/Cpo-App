import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/screens/pages/login/controller/login_controller.dart';
import 'package:cpu_management/screens/widget/one_c_button.dart';
import 'package:cpu_management/screens/widget/one_c_onboarding_header.dart';
import 'package:cpu_management/screens/widget/one_c_terms_and_privacy.dart';
import 'package:cpu_management/screens/widget/one_c_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final loginController = ChangeNotifierProvider<LoginController>((ref) {
    return LoginController();
  });

  @override
  void initState() {
    super.initState();
    // ref.read(authProvider).checkForUpdate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const OneCTermsAndPolicy(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const OneCOnboardingHeader(),
            SizedBox(
              height: 4.h,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Text(
                  "Login With Your email",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 8.0,
              ),
              child: OneCTextField(
                controller: ref.read(loginController).mailController,
                inputType: TextInputType.emailAddress,
                hintText: "Enter Your email here",
                prefixIcon: Icons.mail,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    activeColor: ConstantColors.primaryColor,
                    value: ref.watch(loginController).staySignedIn,
                    onChanged: (value) {
                      ref
                          .read(loginController)
                          .staySignedForSeveneDays(value ?? false);
                    },
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Stay signed in for 7 days',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: OneCButton(
                onPressed: () async {
                  await ref.read(loginController).sendToVerifyOtp(context);
                },
                width: double.infinity,
                label: AppLocalizations.of(context)!.proceed.toUpperCase(),
                labelColor: ConstantColors.white,
                backgroundColor: ConstantColors.buttonBlack,
              ),
            ),
            const SizedBox(height: 140),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 93.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Not able to login? Contact us",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ConstantColors.okBg,
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.call,
                            color: ConstantColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ConstantColors.okBg,
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.mail,
                            color: ConstantColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
