// room_condition_check_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../components/bavbar/bottomNavbar.dart';
import '../components/bavbar/topNavbar.dart';
import '../components/button/button.dart';
import '../core/constants.dart';
import '../listPage/list_screen.dart';
import 'room_condition_check_screen_provider.dart';

class RoomConditionCheckScreen extends StatefulWidget {
  const RoomConditionCheckScreen({super.key});

  @override
  State<RoomConditionCheckScreen> createState() =>
      _RoomConditionCheckScreenState();
}

class _RoomConditionCheckScreenState
    extends State<RoomConditionCheckScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoomConditionCheckScreenProvider>().init();
    });
  }

  // --- UI Helper Methods ---
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
            context.read<RoomConditionCheckScreenProvider>().formatTime(seconds),
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(FurnitureItem item) {
    if (item.image is String) {
      return Image.asset(item.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image));
    }
    return Container(
        width: 60,
        height: 60,
        color: Colors.orange.shade100,
        child: Icon(item.image as IconData, color: Colors.orange));
  }

  Widget _buildStatusPicker(int index, FurnitureItem item) {
    return Row(
      children: ["ปกติ", "ชำรุด"].map((s) {
        bool active = item.status == s;
        return GestureDetector(
          onTap: () =>
              context.read<RoomConditionCheckScreenProvider>().updateStatus(index, s),
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 25,
              right: 25,
              top: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("แจ้งพบของชำรุดเพิ่มเติม",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                  autofocus: true,
                  onChanged: (v) => extraTitle = v,
                  decoration: const InputDecoration(
                      labelText: "ระบุชื่อสิ่งของ",
                      border: OutlineInputBorder())),
              const SizedBox(height: 20),
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
                          Image.file(tempImage!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover),
                          Positioned(
                              right: 8,
                              top: 8,
                              child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: const Icon(Icons.edit,
                                      color: Colors.white))),
                        ]),
                      ),
              ),
              const SizedBox(height: 25),
              Button(
                  text: "ยืนยันการเพิ่มรายการ",
                  color: Colors.blue,
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
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("กรุณาระบุชื่อสิ่งของ")));
                    }
                  }),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog({String msg = "บันทึกข้อมูลสำเร็จ"}) async {
    await context.read<RoomConditionCheckScreenProvider>().submitCheckCondition();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListScreen(checkInStatus: true, statusConCheck: true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<RoomConditionCheckScreenProvider>(
              builder: (context, provider, _) {
                // หมดเวลา auto confirm
                if (provider.isTimeUp) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showSuccessDialog(msg: "หมดเวลาตรวจเช็ค ระบบยืนยันอัตโนมัติ");
                  });
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
                          const Text("ตรวจเช็ค เฟอร์นิเจอร์",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          _buildTimerBadge(provider.remainingSeconds),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ...provider.furnitureList
                          .asMap()
                          .entries
                          .map((entry) =>
                              _buildFurnitureRow(entry.key, entry.value))
                          .toList(),
                      const SizedBox(height: 30),
                      Button(
                          text: "บันทึกข้อมูลการตรวจเช็ค",
                          onTap: () => _showSuccessDialog(),
                          color: Colors.blue),
                      const SizedBox(height: 12),
                      Button(
                          text: "+ แจ้งของชำรุดที่ไม่มีในรายการ",
                          onTap: () => _showAddExtraDamageSheet(),
                          color: Colors.orange.shade700),
                    ],
                  ),
                );
              },
            ),
            const Positioned(top: 0, left: 0, right: 0, child: Topnavbar()),
            const Positioned(
                bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
          ],
        ),
      ),
    );
  }
}