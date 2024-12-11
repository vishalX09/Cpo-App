import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cpu_management/controller/language_change_controller.dart';
import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/routes.dart';
import 'package:cpu_management/core/utils/one_c_analytics.dart';
import 'package:cpu_management/core/utils/one_c_local_notifications.dart';
import 'package:cpu_management/core/utils/utils.dart';
import 'package:cpu_management/firebase_options.dart';
import 'package:cpu_management/screens/widget/one_c_overlay.dart';
import 'package:cpu_management/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (!kDebugMode) {
        FlutterError.onError = (FlutterErrorDetails details) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
          OneCAnalytics().addToCurrentUserErrorStack({
            'error': details.toJson(),
          });
        };
      }

      await Hive.initFlutter();

      /// box for adding userdata locally
      await Hive.openBox<String>('user');
      await Hive.openBox<String>('fcmtoken');

      await Hive.openBox<String>('notifyAlerts');

      /// initializing local notifications
      await OneCLocalNotifications().initNotifications();

      runApp(const ProviderScope(
        child: MyApp(),
      ));
    },
    (error, stack) {
      if (!kDebugMode) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
      OneCAnalytics().addToCurrentUserErrorStack({
        'error': error.toString(),
        'stack': stack.toString(),
      });
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLifecycleListener _listener;
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;
  bool firstTimeLoad = true;

  @override
  void initState() {
    super.initState();
    setupListener();
  }

  void noInternet() {
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
              "No internet",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void internetAvaiable() {
    AppRoutes.scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: ConstantColors.reviewGreen,
        content: Row(
          children: [
            Icon(
              Icons.sentiment_satisfied_alt,
              color: Colors.white,
            ),
            SizedBox(width: 16),
            Text(
              "You are now online",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setupListener() {
    _listener = AppLifecycleListener(
      onStateChange: (state) {
        if (state == AppLifecycleState.hidden ||
            state == AppLifecycleState.detached) {
          OneCAnalytics().sendCurrentUserActionStack();
        }
      },
    );
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> event) {
        if (firstTimeLoad && event.contains(ConnectivityResult.none)) {
          noInternet();
          firstTimeLoad = false;
          return;
        }
        if (firstTimeLoad && event.contains(ConnectivityResult.wifi) ||
            event.contains(ConnectivityResult.mobile)) {
          return;
        }
        if (event.contains(ConnectivityResult.none)) {
          noInternet();
        } else if (event.contains(ConnectivityResult.wifi) ||
            event.contains(ConnectivityResult.mobile)) {
          internetAvaiable();
        }
        firstTimeLoad = false;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _listener.dispose();
    _connectivitySubscription.cancel();
  }
  final languageChangeProvider =
    ChangeNotifierProvider((ref) => LanguageChangeController());
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final languageController = ref.watch(languageChangeProvider);
      return ResponsiveSizer(
        builder: (context, _, __) {
          return SafeArea(
            child: OneCOverlay(
              child: MaterialApp(
                locale: languageController.appLocale,
                localizationsDelegates:const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('hi')],
                debugShowCheckedModeBanner: false,
                theme: AppTheme(context).theme,
                color: ConstantColors.primaryColor,
                navigatorKey: AppRoutes.navigatorKey,
                initialRoute: AppRoutes.splash,
                routes: AppRoutes.routes,
                scaffoldMessengerKey: AppRoutes.scaffoldMessengerKey,
              ),
            ),
          );
        },
      );
    });
  }
}


