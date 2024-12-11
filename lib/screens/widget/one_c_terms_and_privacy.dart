import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OneCTermsAndPolicy extends StatelessWidget {
  const OneCTermsAndPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            AppLocalizations.of(context)!.byloggininiagreeto,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                launchUrlString(ConstantStrings.termsAndConditionsUrl);
              },
              child: Text(
                AppLocalizations.of(context)!.termsandcondition,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: ConstantColors.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: ConstantColors.primaryColor,
                    ),
              ),
            ),
            Text(
              ' &',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            GestureDetector(
              onTap: () => launchUrlString(ConstantStrings.privacyPolicyUrl),
              child: Text(
                AppLocalizations.of(context)!.privacypolicy,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: ConstantColors.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: ConstantColors.primaryColor,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
