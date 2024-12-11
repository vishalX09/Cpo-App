import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/images.dart';
import 'package:cpu_management/core/constants/routes.dart';
import 'package:cpu_management/core/models/home/profile.dart';
import 'package:cpu_management/core/providers/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.microtask(() => ref.read(homeProvider.notifier).fetchProfile());
  // }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(homeProvider.notifier).fetchProfile();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(ConstantImages.logo, height: 24, width: 31),
                  const SizedBox(width: 9),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${ref.read(homeProvider).profileData?.data.organization.name}",
                          style: TextStyle(
                              color: ConstantColors.iconBlack, fontSize: 12)),
                      Text("Management",
                          style: TextStyle(
                              color: ConstantColors.iconBlack, fontSize: 12))
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: ConstantColors.okBg.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(64),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.notifications,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          AppRoutes.navigatorKey.currentContext!,
                          AppRoutes.profile);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: ConstantColors.okBg,
                        borderRadius: BorderRadius.circular(64),
                      ),
                      child: Center(
                        child: Text(
                          state.profileData?.data.name.isNotEmpty == true
                              ? state.profileData!.data.name[0].toUpperCase()
                              : "P",
                          style: const TextStyle(
                              fontSize: 18, color: ConstantColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? Center(child: Text('Error: ${state.error}'))
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          color: ConstantColors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, ${state.profileData?.data.name ?? 'User'}",
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantColors.lightGrey2),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Today's Stats",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    children: [
                                      const Text("Live"),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: ConstantColors.darkgreenBg,
                                          borderRadius:
                                              BorderRadius.circular(64),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: StatCard(
                                      title: "Today's earnings",
                                      value: "₹1020",
                                      color: ConstantColors.darkgreenBg,
                                      backgroundColor: ConstantColors
                                          .darkgreenBg
                                          .withOpacity(0.1),
                                      imagePath: ConstantImages.ruppeevector,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: StatCard(
                                      title: "Energy consumption",
                                      value: "75 kWh",
                                      color: ConstantColors.primaryColor,
                                      backgroundColor: ConstantColors
                                          .primaryColor
                                          .withOpacity(0.1),
                                      imagePath: ConstantImages.bolt,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Energy Graph",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 16,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ConstantColors
                                                  .dragsheetDividerColor,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(4),
                                            )),
                                        child: Center(
                                          child: Image.asset(
                                            ConstantImages.vector3,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      const Text("-Energy (kWh)",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: ConstantColors
                                                  .dragsheetDividerColor))
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              const SizedBox(
                                height: 200,
                                child:
                                    Placeholder(), // Replace with a chart widget
                              ),
                              const SizedBox(height: 20),
                              if (state.profileData != null)
                                DataTableWidget(
                                    stations: state.profileData!.data.stations),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color backgroundColor;
  final String imagePath;

  const StatCard(
      {super.key,
      required this.title,
      required this.value,
      required this.color,
      required this.backgroundColor,
      required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      height: 100,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, color: ConstantColors.iconBlack),
                ),
              ],
            ),
            Image.asset(imagePath, height: 40, width: 29),
          ],
        ),
      ),
    );
  }
}

class DataTableWidget extends StatelessWidget {
  final List<Station> stations;

  const DataTableWidget({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Location')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Connectors')),
      ],
      rows: stations.map((station) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(station.name)),
            DataCell(Text(station.status)),
            DataCell(Text(
                '${station.availableConnectorCount}/${station.totalConnectorCount}')),
          ],
        );
      }).toList(),
    );
  }
}
