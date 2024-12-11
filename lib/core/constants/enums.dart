import 'package:cpu_management/core/constants/images.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum BottomNavPageType { home, chargers, stats, sessions }

// enum VehicleType {
//   erickshaw('L3', 'Rickshaw', "L3", ConstantImages.electricRickshawWhite),
//   eauto('L5', '3 Wheeler', "L5", ConstantImages.electricAutoWhite),
//   fourwheeler(
//       '4-WHEELER', '4 Wheeler', '4wheeler', ConstantImages.electricCarWhite),
//   twowheeler(
//       '2-WHEELER', '2 Wheeler', '2wheeler', ConstantImages.electricMopedWHite);

//   const VehicleType(this.value, this.type, this.passValue, this.image);
//   final String value;
//   final String type;
//   final String passValue;
//   final String image;

//   String getName(AppLocalizations localizations) {
//     switch (this) {
//       case VehicleType.erickshaw:
//         return localizations.erickshaw;
//       case VehicleType.eauto:
//         return localizations.eauto;
//       case VehicleType.fourwheeler:
//         return localizations.fourwheeler;
//       case VehicleType.twowheeler:
//         return localizations.twowheeler;
//     }
//   }
// }

enum ChargingStatus {
  processing,
  charging,
  stopped,
  finished,
}

enum PaymentMode { cash, online }

enum Language { english, hindi }

enum OneCNotificationId {
  normal(0),
  chargingStarted(101),
  chargingFinished(102),

  /// when user reaches to station after navigation
  userReachesStation(205),

  ///
  goToPlayStore(204),

  awayFromStation(400),
  awayFromStationLogout(401),
  backgroundNotification(300);

  const OneCNotificationId(this.value);
  final int value;
}

enum AppClickActionType {
  CHARGING_DETAILS_PAGE,
  FLUTTER_NOTIFICATION_CLICK,
  CHARGER_PAGE,
  PASS_PAGE,
  NONE,
  CHARGING_COMPLETED,
  CHARGING_STOPPED,
  DEVICE_STATUS,
  CHARGING_ONGOING,
  VEHICLE_ENTRIES
}

AppClickActionType convertToAppClickActionType(String type) {
  switch (type) {
    case 'CHARGING_DETAILS_PAGE':
      return AppClickActionType.CHARGING_DETAILS_PAGE;
    case 'FLUTTER_NOTIFICATION_CLICK':
      return AppClickActionType.FLUTTER_NOTIFICATION_CLICK;
    case 'CHARGER_PAGE':
      return AppClickActionType.CHARGER_PAGE;
    case 'PASS_PAGE':
      return AppClickActionType.PASS_PAGE;
    case 'CHARGING_COMPLETED':
      return AppClickActionType.CHARGING_COMPLETED;
    case 'CHARGING_STOPPED':
      return AppClickActionType.CHARGING_STOPPED;
    case 'DEVICE_STATUS':
      return AppClickActionType.DEVICE_STATUS;
    case 'CHARGING_ONGOING':
      return AppClickActionType.CHARGING_ONGOING;
    case 'VEHICLE_ENTRIES':
      return AppClickActionType.VEHICLE_ENTRIES;
    default:
      return AppClickActionType.NONE;
  }
}

String convertToString(AppClickActionType type) {
  switch (type) {
    case AppClickActionType.CHARGING_DETAILS_PAGE:
      return 'CHARGING_DETAILS_PAGE';
    case AppClickActionType.FLUTTER_NOTIFICATION_CLICK:
      return 'FLUTTER_NOTIFICATION_CLICK';
    case AppClickActionType.CHARGER_PAGE:
      return 'CHARGER_PAGE';
    case AppClickActionType.PASS_PAGE:
      return 'PASS_PAGE';
    case AppClickActionType.CHARGING_COMPLETED:
      return 'CHARGING_COMPLETED';
    case AppClickActionType.CHARGING_STOPPED:
      return 'CHARGING_STOPPED';
    case AppClickActionType.DEVICE_STATUS:
      return 'DEVICE_STATUS';
    case AppClickActionType.CHARGING_ONGOING:
      return 'CHARGING_ONGOING';
    case AppClickActionType.VEHICLE_ENTRIES:
      return 'VEHICLE_ENTRIES';
    default:
      return 'NONE';
  }
}

enum ConnectorType {
  CCS1(
    'CCS 1',
    1,
    'https://chargingbackend.s3.ap-south-1.amazonaws.com/connector-images/CCS1-1.png',
    ConstantImages.ccs1,
  ),
  CCS2(
    'CCS 2',
    2,
    'https://chargingbackend.s3.ap-south-1.amazonaws.com/connector-images/CCS-2-1.png',
    ConstantImages.ccs2,
  ),
  Type1(
    'Type 1',
    3,
    'https://chargingbackend.s3.ap-south-1.amazonaws.com/connector-images/Type1.png',
    ConstantImages.type1,
  ),
  Type2(
    'Type 2',
    4,
    'https://chargingbackend.s3.ap-south-1.amazonaws.com/connector-images/Type-2.png',
    ConstantImages.type2,
  ),
  J1772(
    'J1772',
    5,
    'https://chargingbackend.s3.ap-south-1.amazonaws.com/connector-images/J1772.png',
    ConstantImages.j1772,
  ),
  CHAdeMO(
    'CHAdeMO',
    6,
    'https://chargingbackend.s3.ap-south-1.amazonaws.com/connector-images/CHAdeMO-1.png',
    ConstantImages.chadeMo,
  ),
  GBT(
    'GB/T',
    7,
    'https://chargingbackend.s3.ap-south-1.amazonaws.com/connector-images/GB-T-1.png',
    ConstantImages.gbt,
  ),
  Mennekes(
    'Mennekes',
    8,
    'https://chargingbackend.s3.ap-south-1.amazonaws.com/connector-images/Mennekes.png',
    ConstantImages.nacs,
  ),
  Tesla(
    'Tesla',
    9,
    'https://chargingbackend.s3.ap-south-1.amazonaws.com/connector-images/Tesla-1.png',
    ConstantImages.tesla,
  ),
  NACS(
    'NACS',
    12,
    "https://gomassive-stage.s3.ap-south-1.amazonaws.com/nacs.png",
    ConstantImages.nacs,
  ),
  ACSocket(
    'AC Socket',
    13,
    "https://gomassive-stage.s3.ap-south-1.amazonaws.com/acsocket.png",
    ConstantImages.acSocket,
  );

  const ConnectorType(this.title, this.value, this.url, this.image);
  final String title;
  final int value;
  final String url;
  final String image;
}

enum ChargerStatus {
  available('Available'),
  preparing('Preparing'),
  charging('Charging'),
  processing('Processing'),
  unavailable('Unavailable'),
  offline('Offline'),
  faulted('Faulted'),
  evSuspended('EVSuspended'),
  busy('Busy'),
  none('None');

  const ChargerStatus(this.name);
  final String name;
  static ChargerStatus? fromString(String? status) {
    if (status == null) {
      return ChargerStatus.unavailable;
    }
    String normalizedStatus =
        status.replaceAll(RegExp(r'[\s-_ ]'), '').toLowerCase();
    for (var value in ChargerStatus.values) {
      if (value.name.toLowerCase() == normalizedStatus) {
        return value;
      }
    }
    return ChargerStatus.none;
  }
}

enum DurationType {
  today('today'),
  yesterday('yesterday'),
  last7Days('last7Days'),
  currentMonth('currentMonth'),
  currentYear('currentYear'),
  customRange('customRange');

  final String value;
  const DurationType(this.value);

  factory DurationType.fromString(String value) {
    return DurationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => DurationType.today,
    );
  }

  @override
  String toString() => value;
}
