// housekeeper_room_check_screen.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/HousekeeperRoomCheckPage/provider/HousekeeperRoomCheck_Screen_provider.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entitise/housekeeper_room_entity.dart';
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
    final normalizedStatus = status.trim();
    if (normalizedStatus.contains("ปิดปรับปรุง")) return Colors.grey;
    if (normalizedStatus.contains("รอตรวจสอบ")) return Colors.blue;
    if (normalizedStatus.contains("เสร็จสิ้น")) return Colors.green;
    if (normalizedStatus.contains("กำลังทำความสะอาด") ||
        normalizedStatus.contains("ลูกค้าพัก")) {
      return Colors.orange;
    }
    if (normalizedStatus.contains("รอทำความสะอาด") ||
        normalizedStatus.contains("ยังไม่ได้ทำความสะอาด")) {
      return Colors.red;
    }
    return Colors.grey;
  }

  // ใช้ field "building" จริงจาก backend (rooms.building) ไม่ใช่เดาจาก roomNo
  String _getBuildingLabel(String building) {
    if (building.isEmpty || building == '0') return "ไม่ระบุตึก";
    return "ตึก $building";
  }

  Map<String, List<HousekeeperRoomEntity>> _groupByBuilding(
      List<HousekeeperRoomEntity> rooms) {
    final Map<String, List<HousekeeperRoomEntity>> grouped = {};
    for (final room in rooms) {
      final building = _getBuildingLabel(room.building);
      grouped.putIfAbsent(building, () => []).add(room);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => a.roomNo.compareTo(b.roomNo));
    }
    return grouped;
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: [
        _legendItem("รอทำความสะอาด", Colors.red),
        _legendItem("กำลังทำความสะอาด / มีแขก", Colors.orange),
        _legendItem("รอตรวจสอบ", Colors.blue),
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

  Widget _buildRoomTile(HousekeeperRoomEntity room) {
    final statusColor = _getStatusColor(room.status);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: context.read<HousekeeperRoomCheckScreenProvider>(),
              child: RoomDetailFormScreen(roomNo: room.roomNo),
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
            room.roomNo,
            style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
          ),
        ),
      ),
    );
  }

  Widget _buildBuildingSection(
      String buildingLabel, List<HousekeeperRoomEntity> rooms) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 8),
          title: Row(
            children: [
              Text(buildingLabel,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${rooms.length} ห้อง",
                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: rooms.length,
              itemBuilder: (context, index) => _buildRoomTile(rooms[index]),
            ),
          ],
        ),
      ),
    );
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
                      final grouped = _groupByBuilding(provider.filteredRooms);
                      final buildingKeys = grouped.keys.toList()..sort();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: buildingKeys
                            .map((building) => _buildBuildingSection(
                                building, grouped[building]!))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
                top: 0, left: 0, right: 0, child: Topnavbar(widthFactor: 0.2)),
            const Positioned(
                bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
          ],
        ),
      ),
    );
  }
}
