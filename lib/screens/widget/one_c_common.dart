import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/images.dart';
import 'package:cpu_management/core/constants/routes.dart';
import 'package:cpu_management/core/constants/strings.dart';
import 'package:cpu_management/core/utils/utils.dart';
import 'package:cpu_management/screens/widget/one_c_button.dart';
import 'package:cpu_management/screens/widget/one_c_overlay.dart';
import 'package:cpu_management/screens/widget/one_c_textfield.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


Future<bool> showCommonPopup({
  required BuildContext context,
  required String title,
  String? message,
  String? assetImage,
  bool asScreen = false,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      // close after 3 seconds
      if (!asScreen) {
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            Navigator.pop(context, true);
          }
        });
      }
      return CommonAlertBox(
        title: title,
        message: message,
        assetImage: assetImage,
      );
    },
  ).then((value) {
    return true;
  });
}

Future<bool> showCommonErrorPopup({
  required BuildContext context,
  required String title,
  String? message,
  String? assetImage,
  bool asScreen = false,
  bool showImage = true,
  bool showTryAgain = true,
}) async {
  return await showDialog(
    barrierDismissible: asScreen,
    context: context,
    builder: (context) {
      // close after 3 seconds
      if (!asScreen) {
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            Navigator.pop(context, true);
          }
        });
      }
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: ConstantColors.white,
        surfaceTintColor: ConstantColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: SizedBox(
          width: 80.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showImage)
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Image.asset(
                    ConstantImages.logo,
                  ),
                ),
              if (assetImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                  ),
                  child: Image.asset(
                    assetImage,
                  ),
                ),
              if (showImage)
                const SizedBox(
                  height: 16,
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: ConstantColors.grey.withOpacity(0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(ConstantImages.electricCarWhite),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (message != null)
                              Text(
                                message,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (showTryAgain)
                        OneCButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          suffixWidget: const Icon(
                            Icons.refresh,
                            color: ConstantColors.white,
                          ),
                          width: 100.w,
                          label: 'Try Again',
                          labelColor: ConstantColors.white,
                          backgroundColor: ConstantColors.primaryColor,
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  ).then((value) {
    return value ?? true;
  });
}
double actionButtonWidth = 70.w;
class CommonAlertBox extends StatelessWidget {
  const CommonAlertBox({
    super.key,
    required this.title,
    this.message,
    this.assetImage,
  });

  final String title;
  final String? message;
  final String? assetImage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ConstantColors.white,
      surfaceTintColor: ConstantColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: SizedBox(
        width: 80.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (assetImage != null)
              Image.asset(
                assetImage!,
                height: 25.h,
              ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            if (message != null)
              Text(
                message!,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

void showSuccessSnackbar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ),
  );
}

void showFailureSnackbar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

void showErrorSnackbar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

void showInfoSnackbar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: ConstantColors.primaryColor2,
    ),
  );
}

Shader shaderMask(Rect rect) {
  return const LinearGradient(
    colors: [
      ConstantColors.primaryColor2,
      ConstantColors.primaryColor,
    ],
  ).createShader(rect);
}

Shader primeShaderMask(Rect rect) {
  return const LinearGradient(
    colors: [
      ConstantColors.primeColor1,
      ConstantColors.primeColor2,
    ],
  ).createShader(rect);
}

List<String> allInidanStates = [
  "Andaman and Nicobar Islands",
  "Andhra Pradesh",
  "Arunachal Pradesh",
  "Assam",
  "Bihar",
  "Chandigarh",
  "Chhattisgarh",
  "Dadra and Nagar Haveli",
  "Daman and Diu",
  "Delhi",
  "Goa",
  "Gujarat",
  "Haryana",
  "Himachal Pradesh",
  "Jammu and Kashmir",
  "Jharkhand",
  "Karnataka",
  "Kerala",
  "Ladakh",
  "Lakshadweep",
  "Madhya Pradesh",
  "Maharashtra",
  "Manipur",
  "Meghalaya",
  "Mizoram",
  "Nagaland",
  "Odisha",
  "Puducherry",
  "Punjab",
  "Rajasthan",
  "Sikkim",
  "Tamil Nadu",
  "Telangana",
  "Tripura",
  "Uttar Pradesh",
  "Uttarakhand",
  "West Bengal"
];

Widget addingAmountChips({
  required BuildContext context,
  required List<int> amountsList,
  required Function(int amount, int index) onChipTap,
}) {
  return Wrap(
    spacing: 4,
    runSpacing: 4,
    children: [
      for (int index = 0; index < amountsList.length; index++)
        GestureDetector(
          onTap: () {
            onChipTap(amountsList[index], index);
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ConstantColors.grey,
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                colors: [
                  ConstantColors.primaryColor2.withOpacity(0.15),
                  ConstantColors.primaryColor.withOpacity(0.15),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Text(
                '+ ${amountsList[index].toString()}',
                style: TextStyle(
                  color: ConstantColors.primaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
    ],
  );
}

bool _isInternetPopupShown = false;

Future<void> noInternetPopup() async {
  var isConnectedToInternet = await Connectivity().checkConnectivity();
  if (isConnectedToInternet.contains(ConnectivityResult.none)) {
    var assetImage = ConstantImages.cancel;
    var title = 'Oops!';
    var message = 'Looks like you are not connected to the internet';
    var context = AppRoutes.navigatorKey.currentContext;
    if (context != null && context.mounted && !_isInternetPopupShown) {
      _isInternetPopupShown = true;
      OneCOverlay.hide(context);
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ConstantColors.white,
            surfaceTintColor: ConstantColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Ok',
                    style: TextStyle(color: ConstantColors.primaryColor),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await openAppSettings();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Open Settings',
                    style: TextStyle(color: ConstantColors.primaryColor),
                  ),
                ),
              ),
            ],
            content: SizedBox(
              width: 80.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    assetImage,
                    height: 25.h,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    _isInternetPopupShown = false;
  }
}

Future<bool?> imageSourceSelectionPopup(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: ConstantColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: SizedBox(
          width: 80.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Photo",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const Text(
                'Please choose a method to add a photo',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: const Card(
                        color: ConstantColors.white,
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 16.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: ConstantColors.primaryColor,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: ConstantColors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Camera')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: const Card(
                        color: ConstantColors.white,
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 16.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: ConstantColors.primaryColor,
                                child: Icon(
                                  Icons.image,
                                  color: ConstantColors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Gallery')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              OneCButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                width: 80.w,
                label: 'Cancel'.toUpperCase(),
                labelColor: ConstantColors.buttonBlack,
                backgroundColor: ConstantColors.white,
                borderSide: const BorderSide(
                  color: ConstantColors.buttonBlack,
                  width: 1,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ConnectorStatusPopup extends StatelessWidget {
  const ConnectorStatusPopup({
    super.key,
    this.deviceId,
    this.chargerType,
    this.connectorType,
    this.supply,
    this.unitCost,
    this.status,
    this.isFaulted,
    this.connectConnector,
  });

  final String? deviceId;
  final String? chargerType;
  final String? connectorType;
  final double? supply;
  final double? unitCost;
  final String? status;
  final bool? isFaulted;
  final bool? connectConnector;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ConstantColors.white,
      surfaceTintColor: ConstantColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 80.w,
        decoration: BoxDecoration(
          color: ConstantColors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (connectConnector == true)
                  ? 'Please connect the connector to your vehicle & Scan Again!'
                  : (isFaulted == true)
                      ? 'Device Status Faulted!'
                      : (deviceId != null)
                          ? 'Connector Status Unavailable!'
                          : 'Invalid Device Id!',
              style: const TextStyle(
                color: ConstantColors.unavailableRed,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (deviceId != null && isFaulted != true) ...[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ConstantColors.unavailableRed.withOpacity(0.10),
                      ConstantColors.unavailableRed.withOpacity(0.00),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: const Border(
                      top: BorderSide(
                          color: ConstantColors.unavailableRed, width: 4)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                margin: const EdgeInsets.all(1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Device details'.toUpperCase(),
                        style: const TextStyle(
                          color: ConstantColors.okBg,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'QR CODE ID',
                          style: TextStyle(
                            color: ConstantColors.okBg,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          deviceId ?? 'NA',
                          style: const TextStyle(
                            color: ConstantColors.okBg,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Charger Type',
                                style: TextStyle(
                                  color: ConstantColors.okBg,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                chargerType ?? 'NA',
                                style: const TextStyle(
                                  color: ConstantColors.okBg,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Connector Type',
                                style: TextStyle(
                                  color: ConstantColors.okBg,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    ConstantImages.chargingPinLogo,
                                    height: 18,
                                    width: 18,
                                    color: ConstantColors.okBg,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    connectorType ?? 'NA',
                                    style: const TextStyle(
                                      color: ConstantColors.okBg,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Supply',
                                style: TextStyle(
                                  color: ConstantColors.okBg,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${supply}kW',
                                style: const TextStyle(
                                  color: ConstantColors.okBg,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Unit Cost',
                                style: TextStyle(
                                  color: ConstantColors.okBg,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${ConstantStrings.ruppee}$unitCost/kWh',
                                style: const TextStyle(
                                  color: ConstantColors.okBg,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Text(
                (isFaulted == true)
                    ? 'Please check the QR code and device and try again'
                    : 'Please check the QR code or device ID and try again',
                style: const TextStyle(
                  color: ConstantColors.okBg,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
            ],
            const SizedBox(
              height: 8,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Need Help?',
                style: TextStyle(
                  color: ConstantColors.okBg,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    launchUrlString("tel:01143146973");
                  },
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: ConstantColors.offWhiteGradient,
                    ),
                    child: ShaderMask(
                      shaderCallback: primeShaderMask,
                      child: Padding(
                        padding: EdgeInsets.all((20 / 2) + 3),
                        child: Icon(
                          Icons.phone,
                          color: ConstantColors.buttonBlack,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    var uri = Uri(
                      scheme: 'mailto',
                      path: 'support@1charging.com',
                      query: 'subject=Need Support!&body=',
                    );
                    await launchUrl(uri);
                  },
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: ConstantColors.offWhiteGradient,
                    ),
                    child: ShaderMask(
                      shaderCallback: primeShaderMask,
                      child: Padding(
                        padding: EdgeInsets.all((20 / 2) + 3),
                        child: Icon(
                          Icons.email,
                          color: ConstantColors.buttonBlack,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                // GestureDetector(
                //   onTap: () {
                //     launchUrlString("sms://01143146973");
                //   },
                //   child: const DecoratedBox(
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       gradient: ConstantColors.offWhiteGradient,
                //     ),
                //     child: ShaderMask(
                //       shaderCallback: primeShaderMask,
                //       child: Padding(
                //         padding: EdgeInsets.all((20 / 2) + 3),
                //         child: Icon(
                //           Icons.message,
                //           color: ConstantColors.black2,
                //           size: 24,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ConstantColors.white,
                border: Border.all(
                  color: ConstantColors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: OneCButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                width: 100.w,
                label: 'Back'.toUpperCase(),
                labelColor: ConstantColors.buttonBlack,
                backgroundColor: ConstantColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> showConnectorStatusPopup({
  required BuildContext context,
  String? deviceID,
  String? chargerType,
  String? connectorType,
  double? supply,
  double? unitCost,
  String? status,
  bool? isFaulted,
  bool? connectConnector,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return ConnectorStatusPopup(
        deviceId: deviceID,
        chargerType: chargerType,
        connectorType: connectorType,
        supply: supply,
        unitCost: unitCost,
        status: status,
        isFaulted: isFaulted ?? false,
        connectConnector: connectConnector ?? false,
      );
    },
  ).then((value) {
    return value ?? false;
  });
}

class DeleteAccountPopup extends StatefulWidget {
  const DeleteAccountPopup({
    super.key,
  });

  @override
  State<DeleteAccountPopup> createState() => _DeleteAccountPopupState();
}

class _DeleteAccountPopupState extends State<DeleteAccountPopup> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ConstantColors.white,
      surfaceTintColor: ConstantColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 80.w,
        decoration: BoxDecoration(
          color: ConstantColors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),
              const Column(
                children: [
                  Text(
                    'Delete Account!',
                    style: TextStyle(
                      color: ConstantColors.black3,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Are you sure you want to delete this account?',
                    style: TextStyle(
                      color: ConstantColors.black2,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Provide your email address*',
                    style: TextStyle(
                      color: ConstantColors.black3,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  OneCTextField(
                    inputType: TextInputType.text,
                    controller: emailController,
                    hintText: 'Email address',
                    textLimit: 72,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Reason for deleting account',
                    style: TextStyle(
                      color: ConstantColors.black3,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  OneCTextField(
                    inputType: TextInputType.text,
                    controller: reasonController,
                    hintText: 'Type your reason here',
                    textLimit: 150,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, {
                          'email': '',
                          'reason': '',
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ConstantColors.white,
                          border: Border.all(
                            color: ConstantColors.grey,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12.0),
                        margin: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            'cancel'.toUpperCase(),
                            style: const TextStyle(
                              color: ConstantColors.buttonBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () {
                        if (emailController.text.trim().isEmpty ||
                            !isValidEmail(emailController.text.trim())) {
                          showErrorSnackbar(
                            context: context,
                            message: 'Please provide your valid email address',
                          );
                          return;
                        }
                        Navigator.pop(context, {
                          'email': emailController.text,
                          'reason': reasonController.text,
                        });
                      },
                      child: Container(
                        width: 32.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ConstantColors.white,
                          border: Border.all(
                            color: ConstantColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12.0),
                        margin: const EdgeInsets.all(16.0),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            'proceed'.toUpperCase(),
                            style: const TextStyle(
                              color: ConstantColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>?> showDeleteAccountPopup({
  required BuildContext context,
  bool asScreen = false,
}) async {
  return await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return const DeleteAccountPopup();
    },
  );
}

Future<void> noInternet({bool showSnackbar = true}) async {
  var isConnectedToInternet = await Connectivity().checkConnectivity();
  if (isConnectedToInternet.contains(ConnectivityResult.none)) {
    var context = AppRoutes.navigatorKey.currentContext;
    if (context != null && context.mounted && !_isInternetPopupShown) {
      _isInternetPopupShown = true;
      OneCOverlay.hide(context);
      if (showSnackbar) {
        AppRoutes.scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: ConstantColors.reviewRed,
            content: Row(
              children: [
                Icon(
                  Icons.signal_cellular_nodata_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 16),
                Text(
                  'No internet connection',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    _isInternetPopupShown = false;
  }
}

// // ignore: camel_case_types
// class popUp extends StatelessWidget {
//   final String title;
//   final String message;
//   final String action;
//   final VoidCallback onAction;
//   final String cancel;
//   final VoidCallback? onCancel;

//   // New style parameters
//   final TextStyle? titleStyle;
//   final TextStyle? messageStyle;
//   final TextStyle? actionStyle;
//   final TextStyle? cancelStyle;

//   const popUp({
//     super.key,
//     required this.title,
//     required this.message,
//     required this.action,
//     required this.onAction,
//     required this.cancel,
//     this.onCancel,
//     this.titleStyle,
//     this.messageStyle,
//     this.actionStyle,
//     this.cancelStyle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: FittedBox(
//         fit: BoxFit.scaleDown,
//         child: Text(
//           title,
//           style: titleStyle ?? Theme.of(context).textTheme.displayLarge,
//         ),
//       ),
//       content: Text(
//         message,
//         textAlign: TextAlign.center,
//         style: messageStyle ?? Theme.of(context).textTheme.displayLarge,
//       ),
//       actions: [
//         Row(
//           children: [
//             Expanded(
//                         child: OneCButton(
//                           onPressed: () async {
//                                Navigator.of(context).pop();
//                           },
//                           width: actionButtonWidth,
//                           label: AppLocalizations.of(context)!.no,
//                           labelColor: ConstantColors.red,
//                           backgroundColor: ConstantColors.white,
//                           borderSide: const BorderSide(
//                             color: ConstantColors.black2,
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: OneCButton(
//                           onPressed: () async {
//                             onAction;
//                           },
//                           width: actionButtonWidth,
//                           label: action,
//                           labelColor: ConstantColors.darkgreenBg,
//                           backgroundColor: ConstantColors.white,
//                           borderSide: const BorderSide(
//                             color: ConstantColors.black2,
//                             width: 2,
//                           ),
//                         ),
//                       ),
//           ],
//         )
//       ],
//     );
//   }
// }
