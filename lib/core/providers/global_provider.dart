import 'package:cpu_management/core/providers/auth/auth_provider.dart';
import 'package:cpu_management/core/providers/main/main_provider.dart';
import 'package:cpu_management/core/providers/stats/sse_session_details.dart';
import 'package:cpu_management/screens/pages/chargers/chargers_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final languageChangeProvider =
//     ChangeNotifierProvider<LanguageChangeController>((ref) {
//   return LanguageChangeController();
// });

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

final mainProvider = ChangeNotifierProvider<MainProvider>((ref) {
  return MainProvider();
});

final chargingStationProvider =
    StateNotifierProvider<ChargingStationNotifier, ChargingStationState>((ref) {
  return ChargingStationNotifier();
});

final stationStatsProvider =
    StateNotifierProvider<StationStatsNotifier, StationStatsState>((ref) {
  return StationStatsNotifier();
});
