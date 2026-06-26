import 'package:flutter/material.dart';

import 'package:hotel_management_system/presentation/components/button/button.dart';

import '../core/constants.dart';
import '../core/form_enum.dart';

class RoomDetailFormScreen extends StatefulWidget {
  final String roomNo;
  const RoomDetailFormScreen({super.key, required this.roomNo});

  @override
  State<RoomDetailFormScreen> createState() => _RoomDetailFormScreenState();
}

class _RoomDetailFormScreenState extends State<RoomDetailFormScreen> {
  String _cleaningStatus = "ยังไม่ได้ทำความสะอาด";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("บันทึกข้อมูลห้อง ${widget.roomNo}"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("อัปเดตสถานะการทำความสะอาด",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            _buildDropdown(),
            const SizedBox(height: 25),
            const Text("ตรวจสอบความเรียบร้อย (แนบรูปภาพ)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            _sectionTitle("เตียงนอน"),
            createInputField(InputFieldType.paymentSlip,
                textLabel: "ถ่ายรูปเตียงนอน", onTap: () {
              // Logic สำหรับ ImagePicker
            }),
            _sectionTitle("เครื่องปรับอากาศ / อุปกรณ์ไฟฟ้า"),
            createInputField(InputFieldType.paymentSlip,
                textLabel: "ถ่ายรูปแอร์/รีโมท", onTap: () {}),
            _sectionTitle("ห้องน้ำ"),
            createInputField(InputFieldType.paymentSlip,
                textLabel: "ถ่ายรูปความสะอาดห้องน้ำ", onTap: () {}),
            const SizedBox(height: 40),
            Button(
                text: "บันทึกข้อมูล",
                onTap: () {
                  Navigator.pop(context); // บันทึกเสร็จกลับหน้าเดิม
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("บันทึกห้อง ${widget.roomNo} สำเร็จ")));
                },
                color: Colors.green),
            const SizedBox(height: 12),
            Button(
                text: "แจ้งชำรุด / ส่งซ่อม",
                onTap: () => _showDamageReport(context),
                color: Colors.red),
          ],
        ),
      ),
    );
  }

  // --- Widget ส่วนเสริม ---
  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: Constants.inputFieldFillColor,
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _cleaningStatus,
          isExpanded: true,
          items: [
            "ยังไม่ได้ทำความสะอาด",
            "กำลังทำความสะอาด",
            "ทำความสะอาดเสร็จสิ้น"
          ]
              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
          onChanged: (v) => setState(() => _cleaningStatus = v!),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 5),
        child: Text(title,
            style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
      );

  // --- ฟังก์ชันแสดงหน้าต่างแจ้งซ่อม (ยกมาจากหน้าเดิม) ---
  void _showDamageReport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 15),
            Text("รายงานของชำรุด ห้อง ${widget.roomNo}", // ใส่เลขห้องให้ชัดเจน
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            createInputField(InputFieldType.fullName,
                textLabel: "ชื่อสิ่งของที่ชำรุด (เช่น หลอดไฟ, ก๊อกน้ำ)"),
            createInputField(InputFieldType.specialRequest,
                textLabel: "รายละเอียดอาการชำรุด"),
            const SizedBox(height: 20),
            Button(
                text: "ส่งข้อมูลแจ้งซ่อม",
                onTap: () {
                  Navigator.pop(context); // ปิด BottomSheet
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("ส่งรายงานแจ้งซ่อมห้อง ${widget.roomNo} เรียบร้อยแล้ว")));
                },
                color: Colors.red),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

