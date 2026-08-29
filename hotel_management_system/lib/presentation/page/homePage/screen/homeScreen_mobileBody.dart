// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/model/model.dart';
import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/core/constants.dart';
import '../../../../util/widget/core/form_enum.dart';
import '../../../../util/widget/core/typeRoom_enum.dart';
import '../provider/home_screen_provider.dart';

class HomeScreenMobileBody extends StatefulWidget {
  final HomeFilterArgs? filterArgs;

  const HomeScreenMobileBody({super.key, this.filterArgs});

  @override
  State<HomeScreenMobileBody> createState() => _HomeScreenMobileBodyState();
}

class _HomeScreenMobileBodyState extends State<HomeScreenMobileBody> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;

      final provider = context.read<HomeScreenProvider>();

      if (widget.filterArgs != null) {
        // มีวันที่ส่งมาจาก Promotion page -> กรองห้องตามวันที่ทันที
        provider.setDateRange(
          widget.filterArgs!.checkIn,
          widget.filterArgs!.checkOut,
        );
      }
      // ถ้าไม่มี filterArgs -> ไม่ทำอะไร รอให้ user กดเลือกวันที่เอง
    });
  }

  Widget _buildTabButton(BuildContext context, String label, RoomType type) {
    final provider = context.watch<HomeScreenProvider>();
    bool isSelected = provider.selectedRoomType == type;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Constants.primaryColor : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () => context.read<HomeScreenProvider>().selectRoomType(type),
      child: Text(label),
    );
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final provider = context.read<HomeScreenProvider>();
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange:
          provider.checkInDate != null && provider.checkOutDate != null
              ? DateTimeRange(
                  start: provider.checkInDate!, end: provider.checkOutDate!)
              : null,
    );

    if (picked != null) {
      provider.setDateRange(picked.start, picked.end);
    }
  }

  Widget _buildDateFilterChip(BuildContext context) {
    final provider = context.watch<HomeScreenProvider>();
    final hasDateFilter =
        provider.checkInDate != null && provider.checkOutDate != null;

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () => _pickDateRange(context),
          icon: const Icon(Icons.calendar_today, size: 16),
          label: Text(
            hasDateFilter
                ? "${provider.checkInDate!.day}/${provider.checkInDate!.month} - ${provider.checkOutDate!.day}/${provider.checkOutDate!.month}"
                : "เลือกวันที่เข้าพัก",
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Constants.primaryColor,
            side: BorderSide(color: Constants.primaryColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
          ),
        ),
        if (hasDateFilter) ...[
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () =>
                context.read<HomeScreenProvider>().clearDateFilter(),
            tooltip: "ล้างตัวกรองวันที่",
          ),
        ],
      ],
    );
  }

  /// สถานะตอนยังไม่ได้เลือกวันที่ -> บอก user ให้เลือกวันที่ก่อน แทนที่จะแสดงห้องทั้งหมด
  Widget _buildEmptyDatePrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_month, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          const Text(
            "กรุณาเลือกวันที่เข้าพัก\nเพื่อดูห้องว่าง",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => _pickDateRange(context),
            child: const Text("เลือกวันที่"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Topnavbar(
                  widthFactor: 0.2,
                )),
            Positioned(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 83),
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildDateFilterChip(context)),
                        Row(
                          children: [
                            SizedBox(
                                width: screenWidth * 0.3,
                                child:
                                    createInputField(InputFieldType.search)),
                            GestureDetector(
                              onTap: () {
                                print("ค้นหา");
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Constants.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.search,
                                    color: Constants.white, size: 35),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildTabButton(context, "ห้องพัก", RoomType.rooms),
                        const SizedBox(width: 10),
                        _buildTabButton(context, "บ้านพัก", RoomType.house),
                      ],
                    ),
                    SizedBox(height: 8),
                    Consumer<HomeScreenProvider>(
                        builder: (context, provider, child) {
                      return Expanded(
                        child: !provider.hasDateFilter
                            ? _buildEmptyDatePrompt(context)
                            : provider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : provider.errorMessage.isNotEmpty
                                    ? Center(child: Text(provider.errorMessage))
                                    : createBoxShowData(
                                        provider.selectedRoomType,
                                        provider.roomData,
                                        len: provider.len,
                                        crossAxisCount: 2,
                                      ),
                      );
                    })
                  ],
                ),
              ),
            ),
            Positioned(bottom: 0, right: 0, left: 0, child: Bottomnavbar()),
          ],
        ),
      ),
    );
  }
}