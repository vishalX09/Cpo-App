import 'dart:convert';
import 'package:cpu_management/core/api/api_urls.dart';
import 'package:cpu_management/core/constants/enums.dart';
import 'package:cpu_management/core/models/stats/session_stat.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class StatsRepository {
  final String baseUrl = '${ApiUrls.baseUrl}/api/v4';
  Future<StationStatsResponse> getCPOStats({
    String? station,
    DurationType? type,
    int? startTime,
    int? endTime,
  }) async {
    try {
      final token = Hive.box<String>('user').get('token');
      String query = '';
      if (type == DurationType.customRange) {
        if (startTime == null || endTime == null) {
          throw Exception(
              'startTime and endTime must be provided for custom range');
        }
        query = 'startTime=${startTime.toString()}&endTime=${endTime.toString()}';
      }
      final response = await http.get(
        Uri.parse('${ApiUrls.sessionStat}/${station ?? 'all'}/${type ?? DurationType.today}?$query'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        return StationStatsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load CPO profile: ${jsonData['message']}');
      }
    } catch (e) {
      throw Exception('Error fetching CPO profile: $e');
    }
  }
}
