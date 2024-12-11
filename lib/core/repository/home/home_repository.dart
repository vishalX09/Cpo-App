import 'dart:convert';
import 'package:cpu_management/core/api/api_urls.dart';
import 'package:cpu_management/core/models/home/profile.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class CPOService {
  final String baseUrl = '${ApiUrls.baseUrl}/api/v4';
  Future<CPOResponse> getCPOProfile() async {
    try {
      final token = Hive.box<String>('user').get('token');
      final response = await http.get(
        Uri.parse('$baseUrl/cpo/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        return CPOResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load CPO profile: ${jsonData['message']}');
      }
    } catch (e) {
      throw Exception('Error fetching CPO profile: $e');
    }
  }
}
