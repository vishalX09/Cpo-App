import 'dart:convert';
import 'dart:io';
import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/enums.dart';
import 'package:cpu_management/core/constants/routes.dart';
import 'package:cpu_management/core/dev/logger.dart';
import 'package:cpu_management/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Local notification
class OneCLocalNotifications {
  OneCLocalNotifications();

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for 1C important notification',
    importance: Importance.high,
    playSound: false,
    enableVibration: false,
  );

  final _chargingChannel = const AndroidNotificationChannel(
    'charging_progress',
    'Charging Progress Notifications',
    description: 'This channel is used for 1C charging notification',
    importance: Importance.high,
    playSound: false,
    enableVibration: false,
  );

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
      final fCMToken = Platform.isAndroid
          ? await _firebaseMessaging.getToken()
          : await _firebaseMessaging.getAPNSToken();
      logDebug('Token: $fCMToken');

      // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage); 
      // initPushNotifications();
      // initializePlatformNotifications();

      _saveDeviceToken(fCMToken);
    } catch (e) {
      logError(e.toString());
    }
  }

  // Future<void> initializePlatformNotifications() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@drawable/ic_launcher');

  //   final DarwinInitializationSettings initializationSettingsIOS =
  //       DarwinInitializationSettings(
  //           requestSoundPermission: true,
  //           requestBadgePermission: true,
  //           requestAlertPermission: true,
  //           onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsIOS,
  //   );

  //   await _localNotifications.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: selectNotification,
  //   );

  //   final platform = _localNotifications.resolvePlatformSpecificImplementation<
  //       AndroidFlutterLocalNotificationsPlugin>();
  //   await platform?.createNotificationChannel(_androidChannel);
  // }

  Future<NotificationDetails> _notificationDetails(
      {String? tag, bool? onGoing}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      color: ConstantColors.primaryColor.withOpacity(0.50),
      icon: 'ic_launcher',
      tag: tag,
      ongoing: onGoing ?? false,
      styleInformation: const BigTextStyleInformation(''),
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      threadIdentifier: "thread1",
    );

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {}

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  Future<void> showLocalNotification({
    required OneCNotificationId id,
    required String title,
    required String body,
    required String payload,
    String? tag,
  }) async {
    final platformChannelSpecifics = await _notificationDetails(tag: tag);
    await _localNotifications.show(
      id.value,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> showPeriodicLocalNotification({
    required OneCNotificationId id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.periodicallyShow(
      id.value,
      title,
      body,
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    logDebug('id $id');
  }

  // void selectNotification(NotificationResponse notificationResponse) {
  //   switch (notificationResponse.id) {
  //     case 204:
  //       goToPlayStore(notificationResponse);
  //       break;
  //     case 102:
  //       var context = AppRoutes.navigatorKey.currentContext;
  //       if (context != null) {
  //         Navigator.pushNamed(context, AppRoutes.chargingHistory);
  //       }
  //     default:
  //       var action = jsonDecode(notificationResponse.payload ?? '{}');
  //       AppClickActionType clickAction =
  //           convertToAppClickActionType(action['CLICK_ACTION']);
  //       switch (clickAction) {
  //         case AppClickActionType.FLUTTER_NOTIFICATION_CLICK:
  //           break;
  //         case AppClickActionType.CHARGING_DETAILS_PAGE:
  //         case AppClickActionType.CHARGER_PAGE:
  //         case AppClickActionType.PASS_PAGE:
  //         case AppClickActionType.NONE:
  //         case AppClickActionType.CHARGING_COMPLETED:
  //         case AppClickActionType.CHARGING_STOPPED:
  //         case AppClickActionType.DEVICE_STATUS:
  //         case AppClickActionType.CHARGING_ONGOING:
  //         case AppClickActionType.VEHICLE_ENTRIES:
  //           Navigator.pushNamed(
  //             AppRoutes.navigatorKey.currentContext!,
  //             AppRoutes.home,
  //           );
  //           break;
  //       }
  //       break;
  //   }
  //   logDebug('notificationResponse: ${notificationResponse.id}');
  // }

  void cancelAllNotifications() => _localNotifications.cancelAll();

  goToPlayStore(NotificationResponse response) {
    if (response.payload == 'update_app' && response.id == 204) {
      if (Platform.isAndroid || Platform.isIOS) {
        final appId = Platform.isAndroid
            ? 'in.one.charging'
            : '1c-ev-charging/id6478754214';
        final url = Uri.parse(
          Platform.isAndroid
              ? "https://play.google.com/store/apps/details?id=$appId"
              : "https://apps.apple.com/app/$appId",
        );
        launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }

  Future<NotificationDetails> _chargingNotificationDetails(
      double maxProgress, double currentProgress) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      _chargingChannel.id,
      _chargingChannel.name,
      channelDescription: _chargingChannel.description,
      onlyAlertOnce: true,
      importance: Importance.max,
      priority: Priority.max,
      color: ConstantColors.chargerChargingGreen,
      icon: '@mipmap/ic_launcher',
      playSound: false,
      ticker: 'ticker',
      ongoing: true,
      styleInformation: const BigTextStyleInformation(''),
      showProgress: true,
      maxProgress: maxProgress.round(),
      progress: currentProgress.round(),
      colorized: true,
      enableVibration: false,
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
      category: AndroidNotificationCategory.progress,
      tag: 'charging-notification',
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      threadIdentifier: "charging",
      interruptionLevel: InterruptionLevel.passive,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  Future<void> showChargingProgressNotification({
    required OneCNotificationId id,
    required String title,
    required String body,
    String? payload,
    required double maxProgress,
    required double currentProgress,
  }) async {
    final platformChannelSpecifics =
        await _chargingNotificationDetails(maxProgress, currentProgress);
    await _localNotifications.show(
      id.value,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void handleMessage(RemoteMessage? message) {
    logDebug('notification message: ${message.toString()}');
    if (message == null) return;

    showNotification(message.notification!.title!, message.toString());
  }

  // Future initPushNotifications() async {
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

  //   FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  //   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   FirebaseMessaging.onMessage.listen((message) {
  //     final notification = message.notification;
  //     if (notification == null && message.data.isEmpty) return;

  //     if (message.data.isNotEmpty &&
  //         message.notification?.android?.channelId == '1') {
  //       showChargingProgressNotification(
  //           id: OneCNotificationId.chargingStarted,
  //           title: notification?.title! ?? '',
  //           body: notification?.body! ?? '',
  //           payload: '',
  //           maxProgress: double.parse(message.data['max'].toString()),
  //           currentProgress: double.parse(message.data['current'].toString()));
  //     }

  //     if (message.notification?.android?.channelId == '204') {
  //       goToPlayStore(const NotificationResponse(
  //           notificationResponseType:
  //               NotificationResponseType.selectedNotification));
  //     }

  //     if (message.data.isNotEmpty) {
  //       var messageData = jsonEncode(message.data);
  //       saveNotificationData(message.data); // Save the notification data
  //       Map<String, dynamic> data = jsonDecode(messageData);
  //       debugPrint("Handling a background notification: $data");
  //       AppClickActionType? type =
  //           convertToAppClickActionType(data['CLICK_ACTION']);
  //       if (type == AppClickActionType.CHARGING_COMPLETED ||
  //           type == AppClickActionType.CHARGING_STOPPED) {
  //         OneCLocalNotifications().showNotification(
  //           data['title'] ?? '',
  //           data['message'] ?? '',
  //           OneCNotificationId.backgroundNotification,
  //           messageData,
  //         );
  //       }

  //       if (AppRoutes.navigatorKey.currentContext != null) {
  //         ChangeNotifierProvider(
  //           (ref) {
  //             ref.listen(
  //               alertsProvider,
  //               (previous, next) {
  //                 ref.read(alertsProvider).getAlerts();
  //               },
  //             );
  //           },
  //         );
  //       }
  //     }
  //   });
  // }

  Future<void> showNotification(
    String title,
    String body, [
    OneCNotificationId id = OneCNotificationId.normal,
    String payload = '',
    bool? onGoing,
  ]) async {
    var platformChannelSpecifics = await _notificationDetails(onGoing: onGoing);
    await _localNotifications.show(
      id.value, // Notification ID
      title, // Notification Title
      body, // Notification Body, set as null to remove the body
      platformChannelSpecifics,
      payload: payload, // Notification Payload
    );
  }

  Future<void> _saveDeviceToken(String? token) async {
    if (token != null && token.isNotEmpty) {
      // var tokenRef = _db.collectDeclarations()
      Hive.box<String>('fcmtoken').add(token);
    }
  }

  void clearNotification(OneCNotificationId id, {String? tag}) {
    _localNotifications.cancel(id.value, tag: tag);
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  logDebug('Title: ${message.notification?.title}');
  logDebug('Body: ${message.notification?.body}');
  logDebug('Payload: ${message.data}');

  OneCLocalNotifications().showNotification(
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? 'body');
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await Hive.initFlutter();
//   await Hive.openBox<String>('notifyAlerts');
//   saveNotificationData(message.data);
//   var messageData = jsonEncode(message.data);
//   Map<String, dynamic> data = jsonDecode(messageData);
//   debugPrint("Handling a background message: $data");
//   AppClickActionType? type = convertToAppClickActionType(data['CLICK_ACTION']);
//   if (type == AppClickActionType.CHARGING_COMPLETED ||
//       type == AppClickActionType.CHARGING_STOPPED) {
//     OneCLocalNotifications().showNotification(
//       data['title'] ?? '',
//       data['message'] ?? '',
//       OneCNotificationId.backgroundNotification,
//       messageData,
//     );
//   }

//   if (AppRoutes.navigatorKey.currentContext != null) {
//     ChangeNotifierProvider(
//       (ref) {
//         ref.listen(
//           alertsProvider,
//           (previous, next) {
//             ref.read(alertsProvider).getAlerts();
//           },
//         );
//       },
//     );
//     // Provider.of<AlertsProvider>(AppRoutes.navigatorKey.currentContext, listen: false).getAlerts(data);
//   }
// }

void saveNotificationData(Map<String, dynamic> data) async {
  List<Map<String, dynamic>> alertsMessages = [];
  var notifyBox = Hive.box<String>('notifyAlerts');
  var value = notifyBox.get('alerts');
  alertsMessages.add(data);
  try {
    if (value != null && value.isNotEmpty) {
      alertsMessages = [...alertsMessages, ...jsonDecode(value)];
    }
    await notifyBox.put('alerts', jsonEncode(alertsMessages));
  } catch (e) {
    logError(e.toString());
  }
}
