import 'dart:convert';
import 'package:cpu_management/core/constants/routes.dart';
import 'package:cpu_management/core/dev/logger.dart';
import 'package:cpu_management/core/models/user/user.dart';
import 'package:cpu_management/core/repository/auth/auth_repository.dart';
import 'package:cpu_management/core/utils/one_c_analytics.dart';
import 'package:cpu_management/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

class AuthProvider extends ChangeNotifier {
  User? user;
  String? userId;
  String? token;
  String? language;
  Position? userLocation;
  late Box<String> _userBox;

  final AuthRepository _authRepository = AuthRepository();
  static String userUUID = Hive.box<String>('user').get('user_id') ?? '';

  List<String> userVehicleConnectors = [];
  String _routeToPush = AppRoutes.login;

  AuthProvider() {
    _getUserLocation();
    _userBox = Hive.box<String>('user');
    var userData = _userBox.get('user');
    token = _userBox.get('token');
    userId = _userBox.get('user_id');

    if (userData != null) {
      _routeToPush = AppRoutes.main;
      logSuccess('user: $userData');
      setUser(userData);
      getUserData();

      notifyListeners();
    } else {
      Navigator.pushNamedAndRemoveUntil(
        AppRoutes.navigatorKey.currentContext!,
        _routeToPush,
        (route) => false,
      );
      notifyListeners();
    }
  }

  void _getUserLocation() async {
    userLocation = await Utils.getUserCurrentLocation();
    notifyListeners();
  }

  Future<void> getUserData() async {
    var data = await _authRepository.getUserData();
    if (data.data == null) {
      Navigator.pushNamedAndRemoveUntil(
        AppRoutes.navigatorKey.currentContext!,
        AppRoutes.login,
        (route) => false,
      );
      _userBox.clear();
      notifyListeners();
      return;
    }

    var fcmToken = Hive.box<String>('fcmtoken').values.first;
    logDebug('fcmToken: $fcmToken');
    await _authRepository.saveFCMToken(fcmToken: fcmToken);

    user = data;
    setUser(jsonEncode(data.toJson()));
    OneCAnalytics().setCurrentUserId(userId!);
    OneCAnalytics().logEvent('user_login', parameters: {
      'user_id': userId ?? 'null',
      'location': userLocation?.toJson().toString() ?? 'null',
    });
    OneCAnalytics().addToCurrentUserActionStack({
      'action': 'GETTING_USER_DATA',
      'user_id': userId!,
      'user': user?.toJson(),
      'location': userLocation?.toJson().toString() ?? 'null',
      'time': DateTime.now().hhmms,
    });
    Navigator.pushNamedAndRemoveUntil(
      AppRoutes.navigatorKey.currentContext!,
      _routeToPush,
      (route) => false,
    );
    notifyListeners();
  }

  void setUser(String? user) async {
    if (user == null) {
      return;
    }
    this.user = User.fromJson(jsonDecode(user));
    userId = this.user?.data?.id;
    token = this.user?.data?.token;
    // language = this.user?.data?.language;
    // if (language?.toLowerCase() == 'en') {
    //   LanguageChangeController().changeLanguage(const Locale('en'));
    // } else {
    //   LanguageChangeController().changeLanguage(const Locale('hi'));
    // }
    if (this.user == null || this.user?.data == null) {
      Navigator.pushNamedAndRemoveUntil(
        AppRoutes.navigatorKey.currentContext!,
        AppRoutes.main,
        (route) => false,
      );
      return;
    }
    _userBox.put('user', user);
    _userBox.put('user_id', this.user!.data!.id!);
    _userBox.put('token', this.user!.data!.token!);
    notifyListeners();
  }

  void updateProfileImage(String? profileImage) {
    user!.data!.profilePic = profileImage;
    notifyListeners();
  }

  Future<void> updateUserData() async {
    var data = await AuthRepository().getUserData();
    setUser(jsonEncode(data.toJson()));
    notifyListeners();
  }

}
