// start_work_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../provider/HousekeeperRoomCheck_Screen_provider.dart';
import 'room_detail_form.dart';

class StartWorkScreen extends StatefulWidget {
  final String roomNo;

  const StartWorkScreen({super.key, required this.roomNo});

  @override
  State<StartWorkScreen> createState() => _StartWorkScreenState();
}

class _StartWorkScreenState extends State<StartWorkScreen> {
  bool _isStarting = false;

  Future<void> _startWork() async {
    if (_isStarting) return;

    setState(() => _isStarting = true);

    final provider = context.read<HousekeeperRoomCheckScreenProvider>();

    // reuse endpoint เดิมที่ RoomDetailFormScreen ใช้บันทึกสถานะความสะอาดห้อง
    // (PUT /housekeeper/rooms/:roomNo/cleaning-status) — ไม่ต้องเพิ่ม endpoint
    // ใหม่ เพราะ column/endpoint นี้คือตัวเดียวกับที่กำหนด room.status ที่โชว์
    // อยู่ในหน้ารายการห้องอยู่แล้ว
    final success = await provider.saveRoomDetail(
      roomNo: widget.roomNo,
      cleaningStatus: "กำลังทำความสะอาด",
    );

    if (!mounted) return;

    setState(() => _isStarting = false);

    if (success) {
      // ใช้ pushReplacement แทน push เพื่อไม่ให้กดย้อนกลับจากหน้ารายละเอียด
      // แล้วเจอหน้า "เริ่มทำงาน" ซ้ำ (กดเริ่มงานได้แค่ครั้งเดียวต่อการเข้าห้อง)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: provider,
            child: RoomDetailFormScreen(roomNo: widget.roomNo),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage.isEmpty
                ? 'ไม่สามารถเริ่มงานได้'
                : provider.errorMessage,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      appBar: AppBar(
        title: Text(
          "ห้อง ${widget.roomNo}",
          style: const TextStyle(
            fontSize: Constants.fontSizeTitle,
            fontWeight: Constants.fontWeightBold,
          ),
        ),
        backgroundColor: Constants.white,
        foregroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cleaning_services_rounded,
                size: 72,
                color: Constants.primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                "พร้อมเริ่มทำความสะอาดห้อง ${widget.roomNo} หรือยัง?",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: Constants.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: _isStarting ? "กำลังเริ่มงาน..." : "เริ่มทำงาน",
                  onTap: _isStarting ? () {} : _startWork,
                  color: Constants.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
