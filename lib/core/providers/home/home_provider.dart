import 'package:cpu_management/core/repository/home/home_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cpu_management/core/models/home/profile.dart';

class HomeState {
  final bool isLoading;
  final String? error;
  final CPOResponse? profileData;

  HomeState({
    this.isLoading = false,
    this.error,
    this.profileData,
  });

  // Get all station names from profile
  List<String> getAllStationNames() {
    if (profileData?.data.stations == null) return [];

    try {
      return profileData!.data.stations
          .map((station) => station.name ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting station names: $e');
      }
      return [];
    }
  }

  List<Station> getAllStations() {
    if (profileData?.data.stations == null) return [];

    try {
      return profileData!.data.stations;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting stations: $e');
      }
      return [];
    }
  }

  Station? getStationById(String stationId) {
    if (profileData?.data.stations == null) return null;

    try {
      return profileData!.data.stations
          .firstWhere((station) => station.id == stationId);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting station by ID: $e');
      }
      return null;
    }
  }

  HomeState copyWith({
    bool? isLoading,
    String? error,
    CPOResponse? profileData,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      profileData: profileData ?? this.profileData,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final CPOService _cpoService;

  HomeNotifier(this._cpoService) : super(HomeState());

  Future<void> fetchProfile() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final profile = await _cpoService.getCPOProfile();
      state = state.copyWith(
        isLoading: false,
        profileData: profile,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<List<String>> fetchAndGetStationNames() async {
    await fetchProfile();
    return state.getAllStationNames();
  }
}

final cpoServiceProvider = Provider((ref) => CPOService());

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final cpoService = ref.watch(cpoServiceProvider);
  return HomeNotifier(cpoService);
});
