import 'dart:io';
import 'dart:math';
import 'package:cpu_management/core/constants/enums.dart';
import 'package:cpu_management/core/dev/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Utils {
  static Future<bool> openMap(double lat, double lng) async {
    final url = Platform.isAndroid
        ? 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'
        : 'https://maps.apple.com/?ll=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      return launchUrl(Uri.parse(url));
    }
    return false;
  }

  static Future<Position> getUserCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        var data = await Permission.location.request();
        if (data.isGranted) {
          return await Geolocator.getCurrentPosition();
        }
        // await showDialog(
        //   context: AppRoutes.navigatorKey.currentContext!,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       backgroundColor: ConstantColors.white,
        //       surfaceTintColor: ConstantColors.white,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       title: const Text('Location Permission Required'),
        //       content: const Text(
        //           'We need your location permission to show nearby stations.'),
        //       actions: <Widget>[
        //         TextButton(
        //           child: const Padding(
        //             padding: EdgeInsets.all(8.0),
        //             child: Text('Go to Settings'),
        //           ),
        //           onPressed: () {
        //             openAppSettings();
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //       ],
        //     );
        //   },
        // );
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return Position.fromMap({
        'latitude': 28.457523,
        'longitude': 77.026344,
      });
    }
  }
}

extension StringExtension on String {
  /// Capitalize first letter of string
  ///
  /// Eg: hello -> Hello
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension DDMMMMYYYY on DateTime {
  /// Shows date in dd MMMM yyyy format
  ///
  /// Eg: 27 March 2022
  String get ddMMMyyyy {
    return intl.DateFormat('dd/MM/yyyy').format(this);
  }

  /// Shows time in hh:mm:ss format
  ///
  /// Eg: 10:30:07 (hours: minutes: seconds)
  String get hhmms {
    return intl.DateFormat('hh:mm:ss').format(this);
  }

  String get hhmma {
    return intl.DateFormat('hh:mm a').format(this);
  }
}

extension PreciseDouble on double {
  double get precise => double.parse(toStringAsFixed(3));
}

String calculateDuration(String? alertDate, int sessionStart) {
  if (alertDate == null) {
    return 'N/A';
  }
  DateTime alertDateTime = DateTime.parse(alertDate);
  DateTime sessionStartTime = DateTime.fromMillisecondsSinceEpoch(sessionStart);
  Duration difference = alertDateTime.difference(sessionStartTime);
  if (difference.inSeconds < 0) {
    return 'N/A';
  }
  return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''} '
          '${difference.inMinutes.remainder(60)} min${difference.inMinutes.remainder(60) != 1 ? 's' : ''} '
          '${difference.inSeconds.remainder(60)} sec${difference.inSeconds.remainder(60) != 1 ? 's' : ''}'
      .trim();
}

class FullAddressModel {
  final String fullAddress;
  final String city;
  final String state;
  final String pincode;

  FullAddressModel({
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.pincode,
  });
}

String totalChargingTime(int start, int end, {bool? includeSec = true}) {
  String time = '';
  var sdt = DateTime.fromMillisecondsSinceEpoch(start);
  var edt = DateTime.fromMillisecondsSinceEpoch(end);

  Duration difference = edt.difference(sdt);
  int timeInSeconds = difference.inSeconds;

  // Return '1 sec' if no time has passed
  if (timeInSeconds == 0) return '1 sec';

  if (timeInSeconds > 0) {
    if (includeSec == true || timeInSeconds < 60) {
      time =
          '${timeInSeconds % 60} sec${(timeInSeconds % 60 > 1) ? 's' : ''} $time';
    }
    timeInSeconds =
        (timeInSeconds / 60).truncate(); // Convert seconds to minutes
  }

  if (difference.inMinutes > 0) {
    time =
        '${timeInSeconds % 60} min${(timeInSeconds % 60 > 1) ? 's' : ''} $time';
    timeInSeconds = (timeInSeconds / 60).truncate(); // Convert minutes to hours
  }

  if (difference.inHours > 0) {
    time =
        '${timeInSeconds % 24} hour${(timeInSeconds % 24 > 1) ? 's' : ''} $time';
    timeInSeconds = (timeInSeconds / 24).truncate(); // Convert hours to days
  }

  if (difference.inDays > 0) {
    time = '$timeInSeconds day${(timeInSeconds > 1) ? 's' : ''} $time';
  }

  return time.trim(); // Return the formatted time string
}

/// Returns true if the text is overflowing
///
/// Use this in if statement to check if the text is overflowing
bool hasTextOverflow(
  String text,
  TextStyle style, {
  double minWidth = 0,
  double maxWidth = double.infinity,
  int maxLines = 3,
}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textScaler: TextScaler.noScaling,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: minWidth, maxWidth: maxWidth);
  return textPainter.didExceedMaxLines;
}

/// Returns the initials of the name
///
/// Eg: John Doe -> JD
String getInitials(String name) => name.isNotEmpty
    ? name.trim().split(' ').map((l) => l[0]).take(2).join()
    : 'NA';

int formatPercentDoubleToInt(double percent) {
  String temp = percent.toStringAsFixed(2);
  int res = 0;
  try {
    if (temp.split('.').length == 2) {
      res = int.parse(temp.split('.')[0]);
      if (int.parse(temp.split('.')[1]) >= 50) {
        res++;
      }
    }
  } catch (e) {
    logDebug(e.toString());
  }
  return res;
}

/// get widget y-axis start position
double getWidgetYPosition(GlobalKey key) {
  RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
  if (box?.hasSize == false) {
    return 0;
  }
  Offset? position = box?.localToGlobal(Offset.zero);
  if (position == null || box == null || box.hasSize == false) return 0;
  return position.dy + box.size.height;
}


List<File?> _addImages(
  List<File> newFiles,
  List<File?> imageFiles,
) {
  for (var file in newFiles) {
    int index = imageFiles.indexOf(null);
    if (index != -1) {
      imageFiles[index] = file;
    } else {
      break;
    }
  }
  return imageFiles;
}

List<File?> onRemoveImage(
  File e,
  List<File?> imageFiles,
) {
  int index = imageFiles.indexOf(e);
  imageFiles[index] = null;

  /// shifting all the images to the left and making the rest null for UX
  for (int i = index; i < imageFiles.length - 1; i++) {
    imageFiles[i] = imageFiles[i + 1];
    imageFiles[i + 1] = null;
  }
  return imageFiles;
}

extension StacktraceDetails on FlutterErrorDetails {
  Map<String, dynamic> toJson() => {
        'exception': exception.toString(),
        'stack': stack.toString(),
        'information': informationCollector.toString(),
      };
}

String elapsedTime(DateTime? time) {
  if (time == null) return '0 sec';
  var elapsedTime = time;
  var hours = elapsedTime.hour;
  var minutes = elapsedTime.minute;
  var seconds = elapsedTime.second;
  if (minutes == 0) {
    return '${seconds.toString().padLeft(2, '0')} sec';
  }
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} min';
}

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

/// connector type image
String getConnectorTypeImageLink(String type) {
  var allConnector = ConnectorType.values;
  for (var connector in allConnector) {
    if (type.replaceAll(' ', '').toUpperCase() ==
        connector.title.replaceAll(' ', '').toUpperCase()) {
      return connector.url;
    }
  }
  return '';
}

ConnectorType getConnectorTypeFromName(String type) {
  var allConnector = ConnectorType.values;
  for (var connector in allConnector) {
    if (type.replaceAll(' ', '').toUpperCase() ==
        connector.title.replaceAll(' ', '').toUpperCase()) {
      return connector;
    }
  }
  return ConnectorType.ACSocket;
}

// String getPassDescription(BuildContext context, String passType) {
//   switch (passType.toLowerCase()) {
//     case '1hr':
//       return AppLocalizations.of(context)!.hourly;
//     case '2hr':
//       return AppLocalizations.of(context)!.daily2hours;
//     case '3hr':
//       return AppLocalizations.of(context)!.daily3hours;
//     case '4hr':
//       return AppLocalizations.of(context)!.daily4hours;
//     case '12hr':
//       return AppLocalizations.of(context)!.daily12hours;
//     case '24hr':
//       return AppLocalizations.of(context)!.daily24hours;
//     case '1week':
//       return AppLocalizations.of(context)!.weekly;
//       case '1month':
//       return AppLocalizations.of(context)!.monthly;
//     default:
//       return passType;
//   }
// }

double haversineDistance(Position start, Position end) {
  const double earthRadius = 6371.0; // Radius of the Earth in kilometers

  // Convert coordinates to radians
  final double lat1 = start.latitude * (pi / 180.0);
  final double lon1 = start.longitude * (pi / 180.0);
  final double lat2 = end.latitude * (pi / 180.0);
  final double lon2 = end.longitude * (pi / 180.0);

  // Calculate the differences between the coordinates
  final double dLat = lat2 - lat1;
  final double dLon = lon2 - lon1;

  // Apply the Haversine formula
  final double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final double distance = earthRadius * c;

  return distance; // Distance in kilometers, add "*1000" to get meters
}

Widget buildTextField(
  String label,
  TextEditingController controller,
  String hint, {
  bool isNumeric = false,
  bool isVehicleNumber = false,
  String? errorText,
  int? maxLength,
  bool? vehicleNumber = false,
  VoidCallback? onScanPressed,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: isVehicleNumber
            ? [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                // UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(maxLength),
              ]
            : isNumeric
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(maxLength),
                  ]
                : [],
        onChanged: (value) {
          if (isVehicleNumber) {
            controller.text = controller.text.toUpperCase();
          }
        },
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          errorText: errorText,
          // suffixIcon: vehicleNumber == true
          //     ? GestureDetector(
          //         // Use GestureDetector to wrap the TextField
          //         onTap: () {
          //           if (isVehicleNumber) {
          //             onScanPressed?.call(); // Trigger the scan action
          //           }
          //         },
          //         child:
          //             const Icon(Icons.document_scanner_outlined)) // Scan icon
          //     : null,
        ),
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    ],
  );
}

bool checkVehicleNumberValidity(String text) {
  final RegExp regex1 = RegExp(r'^[A-Z]{2}[0-9]{2}[A-HJ-NP-Z]{1,2}[0-9]{4}$');
  final RegExp regex2 = RegExp(r'^[0-9]{2}BH[0-9]{4}[A-HJ-NP-Z]{1,2}$');
  final RegExp regex3 =
      RegExp(r'^[A-Z]{2}[ -][0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)? [0-9]{4}$');

  if (regex1.hasMatch(text) || regex2.hasMatch(text) || regex3.hasMatch(text)) {
    return true;
  } else {
    return false;
  }
}


// Future<File> compressFile(File file) async {
//   final filePath = file.absolute.path;
//   final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
//   final splitted = filePath.substring(0, (lastIndex));
//   final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
//   return await FlutterImageCompress.compressAndGetFile(
//     filePath,
//     outPath,
//     quality: 10,
//   ).then((compressedFile) async {
//     logDebug('new file -> ${compressedFile?.path} ');
//     return File(compressedFile!.path);
//   });
// }

//   Future<File?> pickImages(BuildContext context, bool fromCamera) async {
//   File? imageFiles;
//   final ImagePicker picker = ImagePicker();

//   try {
//     final pickedFile = await picker.pickImage(
//       source: fromCamera ? ImageSource.camera : ImageSource.gallery,
//     );

//     if (pickedFile == null) {
//       return null;
//     }

//     imageFiles = File(pickedFile.path);
//   } catch (e) {
//     logError(e.toString());
//     return null;
//   }
//   return imageFiles;
// }
