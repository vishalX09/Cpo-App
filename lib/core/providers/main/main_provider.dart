import 'package:cpu_management/core/constants/enums.dart';
import 'package:cpu_management/screens/pages/chargers/chargers_page.dart';
import 'package:cpu_management/screens/pages/home/home_page.dart';
import 'package:cpu_management/screens/pages/sessions/sessions_page.dart';
import 'package:cpu_management/screens/pages/stats/stats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainProvider extends ChangeNotifier {
  BottomNavPageType _currentPage = BottomNavPageType.home;
  BottomNavPageType get currentPage => _currentPage;

  Widget get currentPageWidget {
    switch (_currentPage) {
      case BottomNavPageType.home:
        return const HomePage();
      case BottomNavPageType.chargers:
        return const ChargersPage();
      case BottomNavPageType.stats:
        return const StatsPage();
      case BottomNavPageType.sessions:
        return const SessionsPage();
      default:
        return const HomePage();
    }
  }

  Future<void> changePage(BottomNavPageType page, {WidgetRef? ref}) async {
    if (ref != null) {
      // ref
      //     .read(alertsProvider)
      //     .getAlerts(haveSeen: _currentPage == BottomNavPageType.alert);
      // ref.read(homeProvider).getTodayCollections();
      // ref.read(homeProvider).getAndUpdateStationDetails(
      //     ref.read(authProvider).user!.data!.stationId!);
    }
    _currentPage = page;
    notifyListeners();
  }

  void notifyListenersCall() {
    notifyListeners();
  }
}
