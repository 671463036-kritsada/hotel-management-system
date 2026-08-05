// housekeeper_room_check_screen.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/HousekeeperRoomCheckPage/provider/HousekeeperRoomCheck_Screen_provider.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/core/constants.dart';
import 'room_detail_form.dart';

class HousekeeperRoomCheckScreen extends StatefulWidget {
  const HousekeeperRoomCheckScreen({super.key});

  @override
  State<HousekeeperRoomCheckScreen> createState() =>
      _HousekeeperRoomCheckScreenState();
}

class _HousekeeperRoomCheckScreenState
    extends State<HousekeeperRoomCheckScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HousekeeperRoomCheckScreenProvider>().getRooms();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    if (status.contains("ลูกค้าพัก")) return Colors.orange;
    if (status.contains("รอทำความสะอาด")) return Colors.red;
    if (status.contains("เสร็จสิ้น")) return Colors.green;
    return Colors.grey;
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: [
        _legendItem("รอทำ", Colors.red),
        _legendItem("มีแขก", Colors.orange),
        _legendItem("เสร็จสิ้น", Colors.green),
        _legendItem("ปิดปรับปรุง", Colors.grey),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(
      backgroundColor: Constants.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: 100, bottom: 120, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "แผนผังห้องพัก",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // --- Search Bar ---
                  TextField(
                    controller: _searchController,
                    onChanged: (query) => context
                        .read<HousekeeperRoomCheckScreenProvider>()
                        .filterRooms(query),
                    decoration: InputDecoration(
                      hintText: "ค้นหาหมายเลขห้อง (เช่น 101...)",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Constants.inputFieldFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildLegend(),
                  const SizedBox(height: 15),

                  // --- Grid View ---
                  Consumer<HousekeeperRoomCheckScreenProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (provider.errorMessage.isNotEmpty) {
                        return Center(child: Text(provider.errorMessage));
                      }

                      if (provider.filteredRooms.isEmpty) {
                        return const Center(
                            child: Text("ไม่พบหมายเลขห้องที่ค้นหา"));
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: provider.filteredRooms.length,
                        itemBuilder: (context, index) {
                          final room = provider.filteredRooms[index];
                          Color statusColor = _getStatusColor(room.status);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RoomDetailFormScreen(
                                    roomNo: room.roomNo,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: statusColor, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  room.roomNo,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Topnavbar(
                  widthFactor: 0.2,
                  username: user?.name,
                )),
            const Positioned(
                bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
          ],
        ),
      ),
    );
  }
}
