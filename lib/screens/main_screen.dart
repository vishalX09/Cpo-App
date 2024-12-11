import 'dart:io';
import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/enums.dart';
import 'package:cpu_management/core/constants/images.dart';
import 'package:cpu_management/core/providers/main/main_provider.dart';
import 'package:cpu_management/screens/pages/chargers/chargers_page.dart';
import 'package:cpu_management/screens/pages/home/home_page.dart';
import 'package:cpu_management/screens/pages/sessions/sessions_page.dart';
import 'package:cpu_management/screens/pages/stats/stats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late final ChangeNotifierProvider<MainProvider> mainController;
  DateTime? lastPressed;
  final List<BottomNavPageType> _navigationStack = [BottomNavPageType.home];

  @override
  void initState() {
    super.initState();
    mainController = ChangeNotifierProvider<MainProvider>((ref) => MainProvider());

  }

  @override
  Widget build(BuildContext context) {
    final mainCtrlWatcher = ref.watch(mainController);
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        final now = DateTime.now();
        const exitWarningDuration = Duration(seconds: 2);
        if (_navigationStack.length > 1) {
          setState(() {
            _navigationStack.removeLast();
            mainCtrlWatcher.changePage(_navigationStack.last, ref: ref);
          });
          return;
        }
        if (_navigationStack.length == 1 &&
            (lastPressed == null ||
                now.difference(lastPressed!) > exitWarningDuration)) {
          lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            elevation: 20,
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(48),
            ),
            backgroundColor: ConstantColors.iconBlack.withOpacity(0.7),
            content:  Center(
              child: Text(
                  AppLocalizations.of(context)!.pressagaintoexit,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ConstantColors.secondaryColor),
              ),
            ),
            duration: exitWarningDuration,
          ));
          return;
        }
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else {
          exit(0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: mainCtrlWatcher.currentPage.index,
          children: const [
            HomePage(),
            ChargersPage(),
            StatsPage(),
            SessionsPage()
          ],
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ConstantColors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, -1),
              ),
            ],
            borderRadius: BorderRadius.circular(0),
            color: ConstantColors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomNavigationIcon(
                  enabled:
                      mainCtrlWatcher.currentPage == BottomNavPageType.home,
                  onPressed: () => changePage(BottomNavPageType.home),
                  icon: Icons.home_outlined,
                  image: ConstantImages.currencyruppeecircle,
                  label:AppLocalizations.of(context)!.home,
                ),
                BottomNavigationIcon(
                  enabled: mainCtrlWatcher.currentPage ==
                      BottomNavPageType.chargers,
                  onPressed: () => changePage(BottomNavPageType.chargers),
                  image: ConstantImages.evstation,
                  label: AppLocalizations.of(context)!.charger,
                ),
                BottomNavigationIcon(
                  enabled:
                      mainCtrlWatcher.currentPage == BottomNavPageType.stats,
                  onPressed: () => changePage(BottomNavPageType.stats),
                  image: ConstantImages.barchartimage,
                  label: AppLocalizations.of(context)!.stats,
                ),
                BottomNavigationIcon(
                  enabled:
                      mainCtrlWatcher.currentPage == BottomNavPageType.sessions,
                  onPressed: () => changePage(BottomNavPageType.sessions),
                  image: ConstantImages.history,
                  label:AppLocalizations.of(context)!.sessions,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void changePage(BottomNavPageType page) {
    if (page == BottomNavPageType.home) {}
    else if (page == BottomNavPageType.chargers) {}
    else if (page == BottomNavPageType.stats) {}
    else if (page == BottomNavPageType.sessions) {}
    if (_navigationStack.isEmpty || _navigationStack.last != page) {
      _navigationStack.add(page);
    }

    ref.read(mainController).changePage(page, ref: ref);
    FocusScope.of(context).unfocus();
  }
}

class BottomNavigationIcon extends StatelessWidget {
  final bool enabled;
  final Function onPressed;
  final IconData? icon;
  final String label;
  final int unseenAlerts;
  final String? image;

  const BottomNavigationIcon({
    super.key,
    required this.enabled,
    required this.onPressed,
    this.icon,
    required this.label,
    this.unseenAlerts = 0,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              if(icon != null)...[
                Icon(
                  icon,
                  size: 40,
                  color: enabled
                      ? ConstantColors.primaryColor
                      : ConstantColors.lightGrey,
                ),
              ] else...[
                if(image != null)
                Image.asset(
                  image!,
                  width: 40,
                  height: 40,
                  color: enabled
                      ? ConstantColors.primaryColor
                      : ConstantColors.lightGrey,
                ),
              ],

              if (unseenAlerts > 0)
                Positioned(
                  top: -1,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$unseenAlerts',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(
            width: 16.w,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: enabled ? FontWeight.bold : FontWeight.bold,fontSize: 13
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
