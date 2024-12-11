import 'package:cpu_management/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionsPage extends ConsumerStatefulWidget {
  const SessionsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SessionsPageState();
}

class _SessionsPageState extends ConsumerState<SessionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "Sessions",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Add refresh logic here
        },
        child: const CustomTabBar(),
      ),
    );
  }
}

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with TickerProviderStateMixin {
  late TabController tabController;
  String searchQuery = ""; // Variable to hold the search query

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: const [
                      Tab(
                        child: Text(
                          "Ongoing",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Past Sessions",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              // Ongoing Sessions Tab
              ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Showing 2 Ongoing Sessions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2, // 2 ongoing sessions
                      itemBuilder: (context, index) {
                        return SessionCard(
                          deviceId: "ABC123XYZ",
                          startTime: "2023-11-28 10:30 AM",
                          endTime: "2023-11-28 11:45 AM",
                          earning: "250.50",
                          energy: "25 kWh",
                          isOngoingSession: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Past Sessions Tab
              ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search for session',
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.filter_alt,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Showing all 2510 Sessions",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ConstantColors.lightGrey2
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return SessionCard(
                          deviceId: "ABC123XYZ",
                          startTime: "2023-11-28 10:30 AM",
                          endTime: "2023-11-28 11:45 AM",
                          earning: "250.50",
                          energy: "25 kWh",
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SessionCard extends StatefulWidget {
  final String deviceId;
  final String startTime;
  final String endTime;
  final String earning;
  final String energy;
  final bool isOngoingSession;

  const SessionCard({
    super.key,
    required this.deviceId,
    required this.startTime,
    required this.endTime,
    required this.earning,
    required this.energy,
    this.isOngoingSession = false,
  });

  @override
  _SessionCardState createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: widget.isOngoingSession ? Colors.white : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.deviceId,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                    ),
                    Container(
                      width: 145, 
                      height: 24,
                      decoration: BoxDecoration(
                        color: widget.isOngoingSession 
                          ? Colors.red.withOpacity(0.1) 
                          : ConstantColors.okBg.withOpacity(0.1), 
                        borderRadius: BorderRadius.circular(64), 
                      ),
                      child: Center(
                        child: Text(
                          widget.startTime, 
                          style: TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.w500,
                            color: widget.isOngoingSession ? Colors.red : Colors.black,
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Earning", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 4),
                        Text(
                          "₹${widget.earning}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: ConstantColors.darkgreenBg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Energy", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 4),
                        Text(
                          widget.energy,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ConstantColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        isExpanded 
                          ? Icons.expand_circle_down_sharp 
                          : Icons.expand_circle_down,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isExpanded)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.deviceId,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                      ),
                      Container(
                        width: 145, 
                        height: 24,
                        decoration: BoxDecoration(
                          color: widget.isOngoingSession 
                            ? Colors.red.withOpacity(0.1) 
                            : ConstantColors.okBg.withOpacity(0.1), 
                          borderRadius: BorderRadius.circular(64), 
                        ),
                        child: Center(
                          child: Text(
                            widget.startTime, 
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.w500,
                              color: widget.isOngoingSession ? Colors.red : Colors.black,
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Earning",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "₹29",
                              style: TextStyle(
                                color: ConstantColors.darkgreenBg,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 120),
                        _buildDetailRow("Energy", "2KWh"),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildDetailRow("Station Name", "Noida city center"),
                      const SizedBox(width: 48),
                      _buildDetailRow("Transaction ID", "TX12345678"),
                    ],
                  ),
                  Row(
                    children: [
                      _buildDetailRow("End Time", widget.endTime),
                      const SizedBox(width: 48),
                      _buildDetailRow("Transaction ID", "TX12345678"),
                    ],
                  ),
                  Row(
                    children: [
                      _buildDetailRow("End Time", widget.endTime),
                      const SizedBox(width: 48),
                      _buildDetailRow("Transaction ID", "TX12345678"),
                    ],
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w400
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}