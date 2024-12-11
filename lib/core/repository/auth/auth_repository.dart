import 'dart:convert';
import 'package:cpu_management/core/api/api_urls.dart';
import 'package:cpu_management/core/models/user/user.dart';
import 'package:cpu_management/core/repository/auth/default_repository.dart';

class AuthRepository extends DefaultRepository {
  Future<User> getUserData() async {
    // final token =  Hive.box<String>('user').get('token');
    var res = await apiClient.get(
      url: ApiUrls.getUsers,
      headers: {...headers},
    );
    return User.fromJson(jsonDecode(res.body));
  }

  Future<bool> saveFCMToken({String? fcmToken}) async {
    var res = await apiClient.post(
      url: ApiUrls.saveFCMToken,
      headers: {...headers},
      body: {'token': fcmToken},
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    }
    return false;
  }
}
