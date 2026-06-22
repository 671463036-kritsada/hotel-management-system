import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentataion/HousekeeperRoomCheckPage/room_detail_form.dart';

import '../components/bavbar/bottomNavbar.dart';
import '../components/bavbar/topNavbar.dart';
import '../core/constants.dart';


class HousekeeperRoomCheckScreen extends StatefulWidget {
  const HousekeeperRoomCheckScreen({super.key});

  @override
  State<HousekeeperRoomCheckScreen> createState() =>
      _HousekeeperRoomCheckScreenState();
}

class _HousekeeperRoomCheckScreenState
    extends State<HousekeeperRoomCheckScreen> {
  late List<Map<String, String>> _allRooms;
  List<Map<String, String>> _filteredRooms = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allRooms = List.generate(50, (index) {
      int floor = (index ~/ 10) + 1;
      int roomNum = (index % 10) + 1;
      String roomNo = "$floor${roomNum.toString().padLeft(2, '0')}";

      List<String> statuses = [
        "มีลูกค้าพักอยู่",
        "รอทำความสะอาด",
        "เสร็จสิ้น",
        "ปิดปรับปรุง"
      ];
      return {"no": roomNo, "status": statuses[index % 4]};
    });
    _filteredRooms = _allRooms;
  }

  void _filterRooms(String query) {
    setState(() {
      _filteredRooms =
          _allRooms.where((room) => room['no']!.contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    onChanged: _filterRooms,
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
                  _filteredRooms.isEmpty
                      ? const Center(child: Text("ไม่พบหมายเลขห้องที่ค้นหา"))
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _filteredRooms.length,
                          itemBuilder: (context, index) {
                            final room = _filteredRooms[index];
                            Color statusColor = _getStatusColor(room['status']!);

                            return GestureDetector(
                              onTap: () {
                                // เมื่อกดห้อง ให้เปิดหน้าใหม่ทันที
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RoomDetailFormScreen(
                                      roomNo: room['no']!,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: statusColor, width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    room['no']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            const Positioned(top: 0, left: 0, right: 0, child: Topnavbar()),
            const Positioned(
                bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods ---
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
}