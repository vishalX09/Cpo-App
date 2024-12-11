import 'package:flutter/foundation.dart';

class ApiUrls {
  static const String baseUrl = 'http://backendtest.1charging.com';
  static const String _baseUrl = 'http://backendtest.1charging.com$apiV4';
  // static const String baseUrl = 'http://localhost:3000';
  // static const String _baseUrl = 'http://localhost:3000$apiV4';
  // static const String baseUrl = 'https://backend.1charging.com';
  // static const String _baseUrl = 'https://backend.1charging.com$apiV4';
  // static const String baseUrl = "http://52.66.42.244:3000/api/v4";
  static const String statsEndpoint = "/cpo/stats";
  static const String api = '/api';
  static const String apiV4 = '/api/v4';

  /// Web socket channel url
  // static const String _devWS = 'ws://65.0.53.17:3001';
  static const String _proWS = 'ws://test.1charging.com';
  // static const String _proWS = 'ws://1cev.in';
  static const String webSocketChannelUrl = kDebugMode ? _proWS : _proWS;
  //https://backend.1charging.com/auth/loginWithOtp
  // / auth/otp url
  // static const String sendOtp =
  //     'http://52.66.42.244:3000/auth/loginWithOtpForCPO';
  // static const String verifyOtp =
  //     'http://52.66.42.244:3000/auth/verifyEmailOtp';
  // static const String resendOtp = '$baseUrl/auth/resendEmailOtp';
  static const String sendOtp = '$baseUrl/auth/loginWithOtpForCPO';
  static const String verifyOtp = '$baseUrl/auth/verifyEmailOtp';

  /// hub user
  static const String getUsers = '$_baseUrl/cpo/profile';
  // static const String getUsers = 'http://52.66.42.244:3000/api/v4/cpo/profile';

  /// station details
  // static const String getStationDetails = '$_baseUrl/stations/hub';

  static const String saveFCMToken = '$_baseUrl/cpo/save-fcm-token';
  // static const String saveFCMToken =
  //     'http://52.66.42.244:3000/api/v4/cpo/save-fcm-token';
  static const String chargerDetails = '$_baseUrl/cpo/chargers-details';
  // static const String chargerDetails =
  //     'http://52.66.42.244:3000/api/v4/cpo/chargers-details';

  static const String sessionList = "$_baseUrl/cpo/session";

  static const String sessionStat = "$_baseUrl/cpo/stats";
}
