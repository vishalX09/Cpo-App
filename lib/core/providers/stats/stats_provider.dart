import 'package:cpu_management/core/providers/stats/sse_session_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stationStatsProvider =
    StateNotifierProvider<StationStatsNotifier, StationStatsState>((ref) {
  return StationStatsNotifier();
});
