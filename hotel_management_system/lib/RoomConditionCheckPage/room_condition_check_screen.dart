import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/components/bavbar/bottomNavbar.dart';
import 'package:hotel_management_system/components/bavbar/topNavbar.dart';
import 'package:hotel_management_system/components/button/button.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/listPage/list_screen.dart';
import 'package:image_picker/image_picker.dart';

class RoomConditionCheckScreen extends StatefulWidget {
  const RoomConditionCheckScreen({super.key});

  @override
  State<RoomConditionCheckScreen> createState() =>
      _RoomConditionCheckScreenState();
}

class _RoomConditionCheckScreenState extends State<RoomConditionCheckScreen> {
  Timer? _timer;
  int _startSeconds = 3600;

  final List<Map<String, dynamic>> _furnitureList = [
    {
      "title": "เตียงนอน",
      "image": "assets/images/furnitures/bed.jpg",
      "status": "ปกติ",
      "note": "",
      "damageImage": null
    },
    {
      "title": "เครื่องปรับอากาศ",
      "image": "assets/images/furnitures/airconditioner.jpg",
      "status": "ปกติ",
      "note": "",
      "damageImage": null
    },
    {
      "title": "ตู้เย็น / มินิบาร์",
      "image": "assets/images/furnitures/fridge.jpg",
      "status": "ปกติ",
      "note": "",
      "damageImage": null
    },
    {
      "title": "ทีวี และ รีโมท",
      "image": "assets/images/furnitures/TV.jpg",
      "status": "ปกติ",
      "note": "",
      "damageImage": null
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_startSeconds > 0) {
            _startSeconds--;
          } else {
            _timer?.cancel();
            _autoConfirm();
          }
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  void _autoConfirm() =>
      _showSuccessDialog(msg: "หมดเวลาตรวจเช็ค ระบบยืนยันอัตโนมัติ");

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pickDamageImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      setState(() {
        _furnitureList[index]['damageImage'] = File(image.path);
      });
    }
  }

  void _showAddExtraDamageSheet() {
    String extraTitle = "";
    File? tempImage; // สร้างตัวแปรเก็บรูปชั่วคราวใน Modal

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        // ใช้ StatefulBuilder เพื่อให้รูปโชว์ทันทีที่ถ่ายเสร็จใน Modal
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

              // --- ส่วนที่เปลี่ยนเป็น GestureDetector เหมือนที่คุณต้องการ ---
              GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                      source: ImageSource.camera, imageQuality: 50);
                  if (image != null) {
                    setModalState(() {
                      // อัปเดตหน้าจอข้างใน Modal
                      tempImage = File(image.path);
                    });
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
                        child: Stack(
                          children: [
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
                          ],
                        ),
                      ),
              ),
              // -------------------------------------------------------

              const SizedBox(height: 25),
              Button(
                  text: "ยืนยันการเพิ่มรายการ",
                  color: Colors.blue,
                  onTap: () {
                    if (extraTitle.isNotEmpty) {
                      setState(() {
                        _furnitureList.add({
                          "title": extraTitle,
                          "image": Icons.warning_amber_rounded,
                          "status": "ชำรุด",
                          "note": "",
                          "damageImage":
                              tempImage // เอารูปจาก Modal ไปใส่ใน List หลัก
                        });
                      });
                      Navigator.pop(context);
                    } else {
                      // แจ้งเตือนถ้าลืมใส่ชื่อ
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("กรุณาระบุชื่อสิ่งของ")));
                    }
                  }),
              const SizedBox(height: 40),
            ],
          ),
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
                      _buildTimerBadge(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ..._furnitureList
                      .asMap()
                      .entries
                      .map(
                          (entry) => _buildFurnitureRow(entry.key, entry.value))
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
            ),
            const Positioned(top: 0, left: 0, right: 0, child: Topnavbar()),
            const Positioned(
                bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerBadge() {
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
          Text(_formatTime(_startSeconds),
              style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildFurnitureRow(int index, Map<String, dynamic> item) {
    bool isDamaged = item['status'] == "ชำรุด";
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
                      child: Text(item['title'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600))),
                  _buildStatusPicker(index),
                ],
              ),
              if (isDamaged) _buildDamageDetailBox(index, item),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }

  Widget _buildItemImage(Map<String, dynamic> item) {
    if (item['image'] is String) {
      return Image.asset(item['image'],
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image));
    }
    return Container(
        width: 60,
        height: 60,
        color: Colors.orange.shade100,
        child: Icon(item['image'] as IconData, color: Colors.orange));
  }

  Widget _buildDamageDetailBox(int index, Map<String, dynamic> item) {
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
            onChanged: (val) => item['note'] = val,
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
            onTap: () => _pickDamageImage(index),
            child: item['damageImage'] == null
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
                    child: Stack(
                      children: [
                        Image.file(item['damageImage'],
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
                                    onPressed: () => _pickDamageImage(index)))),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPicker(int index) {
    return Row(
      children: ["ปกติ", "ชำรุด"].map((s) {
        bool active = _furnitureList[index]['status'] == s;
        return GestureDetector(
          onTap: () => setState(() => _furnitureList[index]['status'] = s),
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

  void _showSuccessDialog({String msg = "บันทึกข้อมูลสำเร็จ"}) {
    _timer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.green));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListScreen(checkInStatus: true, statusConCheck: true)));
  }
}
