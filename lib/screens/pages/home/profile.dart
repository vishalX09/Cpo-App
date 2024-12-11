import 'package:cpu_management/core/constants/colors.dart';
import 'package:cpu_management/core/constants/images.dart';
import 'package:cpu_management/core/providers/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Profile",
                    style: TextStyle(
                        color: ConstantColors.iconBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                Container(
                    width: 120,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(ConstantImages.hindiEnglishLogo,
                            height: 24, width: 31),
                        DropdownButton<String>(
                          items:
                              <String>['English', 'Hindi'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        )
                      ],
                    ))
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: ConstantColors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                              radius: 48,
                              backgroundImage:
                                  AssetImage(ConstantImages.profileImage)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${ref.read(homeProvider).profileData?.data.name}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: ConstantColors.black,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 4),
                                Text(
                                    "${ref.read(homeProvider).profileData?.data.email}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: ConstantColors.black,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${ref.read(homeProvider).profileData?.data.phoneNumber}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: ConstantColors.black,
                                            fontWeight: FontWeight.w500)),
                                    GestureDetector(
                                      onTap: () {
                                        // Add logout logic here
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.logout,
                                            size: 24,
                                            color: ConstantColors.cC,
                                          ),
                                          SizedBox(width: 4),
                                          Text("Logout",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: ConstantColors.cC))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: ConstantColors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Organization",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: ConstantColors.lightGrey,
                                            fontWeight: FontWeight.w400)),
                                    Text(
                                        "${ref.read(homeProvider).profileData?.data.organization.name}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: ConstantColors.black,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Role",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: ConstantColors.lightGrey,
                                                fontWeight: FontWeight.w400)),
                                        Text(
                                            "${ref.read(homeProvider).profileData?.data.role}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: ConstantColors.black,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Account created on",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: ConstantColors.lightGrey,
                                                fontWeight: FontWeight.w400)),
                                        Text(
                                          ref
                                                      .read(homeProvider)
                                                      .profileData
                                                      ?.data
                                                      .createdAt !=
                                                  null
                                              ? "${DateFormat('dd/MM/yy').format(ref.read(homeProvider).profileData!.data.createdAt.toLocal())}, ${DateFormat('hh:mm a').format(ref.read(homeProvider).profileData!.data.createdAt.toLocal())}"
                                              : "${DateFormat('dd/MM/yy').format(DateTime.now())} ${DateFormat('hh:mm a').format(DateTime.now())}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: ConstantColors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: ConstantColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Stations under control",
                          style: TextStyle(
                              fontSize: 14,
                              color: ConstantColors.lightGrey,
                              fontWeight: FontWeight.w400)),
                      Divider(
                        color: ConstantColors.black.withOpacity(0.2),
                        thickness: 1,
                      ),
                      const SessionCard(
                          name: "Noida city center",
                          stationName: "M3M sahy city center",
                          address:
                              "Badshahpur Sohna Rd Hwy, Central Park II, Sector 48, Gurugram, Haryana - 122002",
                          numberOfChargePoints: "16",
                          stationAddedOn: "10:45, 16 May 23"),
                      Divider(
                        color: ConstantColors.black.withOpacity(0.2),
                        thickness: 1,
                      ),
                      const SessionCard(
                          name: "Gurgaon Station",
                          stationName: "M3M sahy city center",
                          address:
                              "DLF Phase 2, Sector 25, Gurugram, Haryana - 122002",
                          numberOfChargePoints: "12",
                          stationAddedOn: "14:30, 20 June 23"),
                      Divider(
                        color: ConstantColors.black.withOpacity(0.1),
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
              decoration: const BoxDecoration(color: ConstantColors.white),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Need help?",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ConstantColors.okBg,
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.call,
                            color: ConstantColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ConstantColors.okBg,
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.mail,
                            color: ConstantColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )));
    });
  }
}

class SessionCard extends StatefulWidget {
  final String name;
  final String stationName;
  final String address;
  final String numberOfChargePoints;
  final String stationAddedOn;

  const SessionCard({
    super.key,
    required this.name,
    required this.stationName,
    required this.address,
    required this.numberOfChargePoints,
    required this.stationAddedOn,
  });

  @override
  _SessionCardState createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 0,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                IconButton(
                  icon: Icon(
                    isExpanded
                        ? Icons.expand_less_outlined
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
          ),
          if (isExpanded) ...[
            Container(
              decoration: BoxDecoration(
                color: ConstantColors.black.withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(widget.stationName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Full Address",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400)),
                      const SizedBox(height: 4),
                      Text(
                        widget.address,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ConstantColors.black,
                          fontWeight: FontWeight.bold,
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
                          const Text("No. Of charge points",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                          const SizedBox(height: 4),
                          Text(
                            widget.numberOfChargePoints,
                            style: const TextStyle(
                              fontSize: 14,
                              color: ConstantColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Station added on",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                          const SizedBox(height: 4),
                          Text(
                            widget.stationAddedOn,
                            style: const TextStyle(
                              fontSize: 14,
                              color: ConstantColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.expand_less_outlined),
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
          ],
        ],
      ),
    );
  }
}
