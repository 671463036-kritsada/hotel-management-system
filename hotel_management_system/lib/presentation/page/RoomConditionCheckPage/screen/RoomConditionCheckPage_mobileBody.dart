// room_condition_check_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../util/model/model.dart';
import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../provider/room_condition_check_screen_provider.dart';

class RoomConditionCheckScreenMobileBody extends StatefulWidget {
  final String roomId;
  const RoomConditionCheckScreenMobileBody({super.key, required this.roomId});

  @override
  State<RoomConditionCheckScreenMobileBody> createState() =>
      _RoomConditionCheckScreenMobileBodyState();
}

class _RoomConditionCheckScreenMobileBodyState
    extends State<RoomConditionCheckScreenMobileBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoomConditionCheckScreenProvider>().init(widget.roomId);
    });
  }

  Widget _buildTimerBadge(int seconds) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.shade200)),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Colors.red, size: 20),
          const SizedBox(width: 5),
          Text(
            context
                .read<RoomConditionCheckScreenProvider>()
                .formatTime(seconds),
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(FurnitureItem item) {
    if (item.image is String && (item.image as String).isNotEmpty) {
      return Image.asset(item.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image));
    }
    // image เป็น null หรือรายการที่เพิ่มเอง -> แสดงไอคอนเตือนแทน
    return Container(
        width: 60,
        height: 60,
        color: Colors.orange.shade100,
        child: const Icon(Icons.warning_amber_rounded, color: Colors.orange));
  }

  Widget _buildStatusPicker(int index, FurnitureItem item) {
    return Row(
      children: ["ปกติ", "ชำรุด"].map((s) {
        bool active = item.status == s;
        return GestureDetector(
          onTap: () => context
              .read<RoomConditionCheckScreenProvider>()
              .updateStatus(index, s),
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
                color: active
                    ? (s == "ปกติ" ? Colors.green : Colors.red)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(25)),
            child: Text(s,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: active ? Colors.white : Colors.grey[600])),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDamageDetailBox(int index, FurnitureItem item) {
    final provider = context.read<RoomConditionCheckScreenProvider>();
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.red.shade50.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade300, width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("รายละเอียดความเสียหาย",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            onChanged: (val) => provider.updateNote(index, val),
            decoration: InputDecoration(
                hintText: "กรอกหมายเหตุที่นี่...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => provider.pickDamageImage(index),
            child: item.damageImage == null
                ? Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400)),
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_enhance,
                              size: 30, color: Colors.grey),
                          Text("กดเพื่อถ่ายรูปความเสียหาย",
                              style: TextStyle(color: Colors.grey))
                        ]),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(children: [
                      Image.file(item.damageImage!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover),
                      Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white),
                                  onPressed: () =>
                                      provider.pickDamageImage(index)))),
                    ]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFurnitureRow(int index, FurnitureItem item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildItemImage(item)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(item.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600))),
                  _buildStatusPicker(index, item),
                ],
              ),
              if (item.status == "ชำรุด") _buildDamageDetailBox(index, item),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }

  void _showAddExtraDamageSheet() {
    String extraTitle = "";
    File? tempImage;

    //ดักจับ provider ไว้ก่อนเปิด modal เพราะ context ข้างใน builder ของ
    // showModalBottomSheet อยู่คนละ tree กับ context ปัจจุบัน หาไม่เจอ provider
    final provider = context.read<RoomConditionCheckScreenProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider.value(
        value: provider,
        child: StatefulBuilder(
          builder: (context, setModalState) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.warning_amber_rounded,
                          color: Colors.orange.shade700, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("แจ้งของชำรุดเพิ่มเติม",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("ระบุรายการที่ไม่มีในรายการตรวจเช็ค",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  autofocus: true,
                  onChanged: (v) => extraTitle = v,
                  decoration: InputDecoration(
                    labelText: "ชื่อสิ่งของที่ชำรุด",
                    prefixIcon: const Icon(Icons.inventory_2_outlined),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Constants.primaryColor, width: 2)),
                  ),
                ),
                const SizedBox(height: 16),
                Text("รูปภาพความเสียหาย",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700])),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 50);
                    if (image != null) {
                      setModalState(() => tempImage = File(image.path));
                    }
                  },
                  child: tempImage == null
                      ? Container(
                          height: 130,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1.5)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_enhance_outlined,
                                    size: 36, color: Colors.grey[400]),
                                const SizedBox(height: 6),
                                Text("กดเพื่อถ่ายรูปความเสียหาย",
                                    style: TextStyle(
                                        color: Colors.grey[400], fontSize: 13)),
                              ]),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(children: [
                            Image.file(tempImage!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover),
                            Positioned(
                                right: 10,
                                top: 10,
                                child: CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    child: const Icon(Icons.edit,
                                        color: Colors.white, size: 18))),
                          ]),
                        ),
                ),
                const SizedBox(height: 24),
                Button(
                  text: "ยืนยันการเพิ่มรายการ",
                  color: Constants.primaryColor,
                  onTap: () {
                    if (extraTitle.isNotEmpty) {
                      context
                          .read<RoomConditionCheckScreenProvider>()
                          .addExtraFurniture(
                            title: extraTitle,
                            damageImage: tempImage,
                          );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("กรุณาระบุชื่อสิ่งของ")));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog({String msg = "บันทึกข้อมูลสำเร็จ"}) async {
    try {
      await context
          .read<RoomConditionCheckScreenProvider>()
          .submitCheckCondition(widget.roomId);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.green));
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/list_page',
        (route) => false,
        arguments: ListScreenArguments(
          checkInStatus: true,
          statusConCheck: true,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("บันทึกข้อมูลไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<RoomConditionCheckScreenProvider>(
              builder: (context, provider, _) {
                if (provider.consumeAutoSubmitTrigger()) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showSuccessDialog(
                        msg: "หมดเวลาตรวจเช็ค ระบบยืนยันอัตโนมัติ");
                  });
                }

                if (provider.isLoading) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: CircularProgressIndicator(),
                  ));
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 200, left: 24, right: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(provider.errorMessage!,
                              textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<RoomConditionCheckScreenProvider>()
                                .init(widget.roomId),
                            child: const Text("ลองใหม่อีกครั้ง"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 140, bottom: 120, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("ตรวจเช็คเฟอร์นิเจอร์",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text("กรุณาตรวจสอบสภาพเฟอร์นิเจอร์ทุกชิ้น",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[500])),
                            ],
                          ),
                          _buildTimerBadge(provider.remainingSeconds),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryChip(
                                "ปกติ", provider.normalCount, Colors.green),
                            _buildSummaryChip(
                                "ชำรุด", provider.damagedCount, Colors.red),
                            _buildSummaryChip(
                                "ยังไม่ตรวจ",
                                provider.furnitureList
                                    .where((f) => f.status.isEmpty)
                                    .length,
                                Colors.grey),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              decoration: BoxDecoration(
                                color: Constants.primaryColor.withOpacity(0.05),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.chair_outlined,
                                      color: Constants.primaryColor, size: 20),
                                  const SizedBox(width: 8),
                                  Text("รายการทั้งหมด",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Constants.primaryColor)),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Constants.primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                        "${provider.furnitureList.length} รายการ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Constants.primaryColor,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: provider.furnitureList
                                    .asMap()
                                    .entries
                                    .map((entry) => _buildFurnitureRow(
                                        entry.key, entry.value))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Button(
                          text: "บันทึกข้อมูลการตรวจเช็ค",
                          onTap: () => _showSuccessDialog(),
                          color: Constants.primaryColor),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () => _showAddExtraDamageSheet(),
                        icon: const Icon(Icons.add),
                        label: const Text("แจ้งของชำรุดเพิ่มเติม"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange.shade700,
                          side: BorderSide(color: Colors.orange.shade700),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Constants.borderRadius)),
                        ),
                      ),
                    ],
                  ),
                );
              },
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

  Widget _buildSummaryChip(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text("$count",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}
