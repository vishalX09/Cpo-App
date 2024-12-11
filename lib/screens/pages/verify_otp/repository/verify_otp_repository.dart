import 'dart:convert';
import 'package:cpu_management/core/api/api_urls.dart';
import 'package:cpu_management/core/dev/logger.dart';
import 'package:cpu_management/core/models/user/user.dart';
import 'package:cpu_management/core/providers/global_provider.dart';
import 'package:cpu_management/core/repository/auth/default_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyOtpRepository extends DefaultRepository {
  Future<User?> verifyOtp({
    required String otp,
    required String mail, 
    required WidgetRef ref,
  }) async {
    try {
      var url = ApiUrls.verifyOtp;
      var res = await apiClient.post(
        url: url,
        body: {
          'email': mail,
          'otp': int.parse(otp),
        },
      );
      ref.read(authProvider).setUser(res.body);
      final data =  User.fromJson(jsonDecode(res.body));
      return data;
    } catch (e) {
      logError('error: $e');
      return null;
    }
  }

  Future<bool> sendOtp({
    required String mail,
    required bool staySignedIn
  }) async {
    try {
      String url = ApiUrls.sendOtp;
      var res = await apiClient.post(
        url: url,
        body: {
          'email': mail,
          'stayLoggedIn':staySignedIn
        },
      );
      if (res.statusCode != 200 && res.statusCode != 201) {
        return false;
      }
      return true;
    } catch (e) {
      logError('error: $e');
      return false;
    }
  }
}
