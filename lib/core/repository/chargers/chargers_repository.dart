import 'dart:convert';
import 'package:cpu_management/core/api/api_urls.dart';
import 'package:cpu_management/core/dev/logger.dart';
import 'package:cpu_management/core/models/chargers/session_list.dart';
import 'package:cpu_management/core/repository/auth/default_repository.dart';

class ChargersRepository extends DefaultRepository {
  Future<ChargingSessionResponse?> sessionsList({
    required String deviceId,
    required int connectorId,
  }) async {
    try {
      String url = '${ApiUrls.sessionList}/$connectorId';
      final Map<String, dynamic> body = {
        'deviceId': deviceId,
        'connectorId': connectorId,
      };
      final response = await apiClient.post(
        url: url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChargingSessionResponse.fromJson(jsonDecode(response.body));
      }
      logError('Session list failed: Status ${response.statusCode}');
      return null;
    } catch (e) {
      logError('Session list failed: ${e.toString()}');
      return null;
    }
  }
}
