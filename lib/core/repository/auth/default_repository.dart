import 'package:cpu_management/core/api/api_client.dart';
import 'package:hive/hive.dart';

/// Extend this class to get the [ApiClient], [token] and [headers] in your repository
///
/// DO NOT USE THIS CLASS DIRECTLY
///
/// DO NOT add any method in this class
abstract class DefaultRepository {
  final ApiClient _apiClient = ApiClient();
  ApiClient get apiClient => _apiClient;

  Map<String, String> get headers => {
        'Authorization':
            'Bearer ${Hive.box<String>('user').get('token') ?? ''}',
      };
  String get token => Hive.box<String>('user').get('token') ?? '';
  String get userId => Hive.box<String>('user').get('user_id') ?? '';
}
