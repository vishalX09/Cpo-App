import 'package:cpu_management/core/providers/charger/charger_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cpu_management/core/constants/colors.dart';

final sessionDetailsProvider =
    ChangeNotifierProvider((ref) => ChargersProvider());

class SessionDetailsScreen extends ConsumerStatefulWidget {
  final String deviceId;
  final int connectorId;

  const SessionDetailsScreen({
    super.key,
    required this.deviceId,
    required this.connectorId,
  });

  @override
  ConsumerState<SessionDetailsScreen> createState() =>
      _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends ConsumerState<SessionDetailsScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSessionData();
    });
  }

  Future<void> _fetchSessionData() async {
    await ref.read(sessionDetailsProvider).sessionList(
          widget.deviceId,
          widget.connectorId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Sessions",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                        "Details",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Sessions",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                const Center(child: Text("Details Tab Content")),
                _buildSessionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsTab() {
    final sessionState = ref.watch(sessionDetailsProvider);

    if (sessionState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (sessionState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: ${sessionState.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchSessionData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final activeSessions = sessionState.sessionData?.data.activeSessions ?? [];
    final completedSessions =
        sessionState.sessionData?.data.completedSessions ?? [];

    if (activeSessions.isEmpty && completedSessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No sessions available',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchSessionData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...activeSessions.map((session) => SessionCard(
                  deviceId: session.deviceId,
                  startTime:
                      DateTime.fromMillisecondsSinceEpoch(session.sessionStart)
                          .toString(),
                  endTime: '',
                  transactionId: session.transactionId.toString(),
                  stationName: session.stationDetails.name,
                  earning: '',
                  energy: '',
                  isOngoingSession: true,
                )),
            ...completedSessions.map((session) => SessionCard(
                  deviceId: session.deviceId,
                  startTime:
                      DateTime.fromMillisecondsSinceEpoch(session.sessionStart)
                          .toString(),
                  endTime:
                      DateTime.fromMillisecondsSinceEpoch(session.sessionStop)
                          .toString(),
                  transactionId: session.transactionId.toString(),
                  stationName: session.stationDetails.name,
                  earning: session.chargedAmount.toString(),
                  energy: '${session.lastMeterValue} kWh',
                  isOngoingSession: false,
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class SessionCard extends StatefulWidget {
  final String deviceId;
  final String startTime;
  final String endTime;
  final String earning;
  final String energy;
  final String transactionId;
  final String stationName;
  final bool isOngoingSession;

  const SessionCard({
    super.key,
    required this.deviceId,
    required this.startTime,
    required this.endTime,
    required this.earning,
    required this.energy,
    required this.transactionId,
    required this.stationName,
    this.isOngoingSession = false,
  });

  @override
  State<SessionCard> createState() => _SessionCardState();
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
      color: widget.isOngoingSession ? Colors.white : ConstantColors.white,
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isOngoingSession
                            ? Colors.red.withOpacity(0.1)
                            : ConstantColors.okBg.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(64),
                      ),
                      child: Text(
                        widget.isOngoingSession ? 'Ongoing' : widget.startTime,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: widget.isOngoingSession
                              ? Colors.red
                              : Colors.black,
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
                        Text(
                          widget.isOngoingSession
                              ? "Transaction ID"
                              : "Earning",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.isOngoingSession
                              ? widget.transactionId
                              : "₹${widget.earning}",
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.isOngoingSession
                                ? ConstantColors.black
                                : ConstantColors.darkgreenBg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isOngoingSession ? "Station" : "Energy",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.isOngoingSession
                              ? widget.stationName
                              : widget.energy,
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
                children: [
                  Row(
                    children: [
                      _buildDetailRow("Start Time", widget.startTime),
                      const SizedBox(width: 48),
                      _buildDetailRow("End Time", widget.endTime),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildDetailRow("Station Name", widget.stationName),
                      const SizedBox(width: 48),
                      _buildDetailRow("Transaction ID", widget.transactionId),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
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
