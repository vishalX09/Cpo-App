import 'package:cpu_management/core/models/chargers/session_list.dart';
import 'package:cpu_management/core/repository/chargers/chargers_repository.dart';
import 'package:flutter/foundation.dart';

class ChargersProvider extends ChangeNotifier {
  final ChargersRepository _chargingFlowRepository = ChargersRepository();
  ChargingSessionResponse? _sessionData;
  bool _isLoading = false;
  String? _error;

  ChargingSessionResponse? get sessionData => _sessionData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<ChargingSessionResponse?> sessionList(
      String deviceId, int connectorId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (kDebugMode) {
        print(
            'Making API call with deviceId: $deviceId, connectorId: $connectorId');
      }

      final response = await _chargingFlowRepository.sessionsList(
        deviceId: deviceId,
        connectorId: connectorId,
      );

      if (kDebugMode) {
        print('API Response: $response');
      }

      if (response != null) {
        _sessionData = response;
        notifyListeners();
        return response;
      } else {
        _error = 'Failed to fetch session data';
        if (kDebugMode) {
          print('Response was null');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in sessionList: $e');
      }
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }
}
