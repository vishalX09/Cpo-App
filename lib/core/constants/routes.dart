import 'package:cpu_management/screens/main_screen.dart';
import 'package:cpu_management/screens/pages/home/profile.dart';
import 'package:cpu_management/screens/pages/login/login_screen.dart';
import 'package:cpu_management/screens/pages/verify_otp/verify_otp_screen.dart';
import 'package:cpu_management/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String verifyOtp = '/verify-otp';
  static const String main = '/main';
  static const String profile = '/profile';


  static Map<String, Widget Function(BuildContext)> routes = {
   splash: (context) => const SplashScreen(),
    login: (context) => const LoginPage(),
    verifyOtp: (context) => VerifyOtpScreen(
          args: ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>,
        ),
    main: (context) => const MainScreen(),
    profile: (context) => const Profile(),
  };

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
}
