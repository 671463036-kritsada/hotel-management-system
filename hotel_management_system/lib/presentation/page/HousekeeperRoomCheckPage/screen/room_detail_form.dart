import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/components/button/button.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/form_enum.dart';
import '../provider/HousekeeperRoomCheck_Screen_provider.dart';

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
      backgroundColor: Constants.white,
      appBar: AppBar(
        title: Text(
          "ห้อง ${widget.roomNo}",
          style: const TextStyle(
              fontSize: Constants.fontSizeTitle,
              fontWeight: Constants.fontWeightBold),
        ),
        backgroundColor: Constants.white,
        foregroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Constants.inputFieldBorderColor, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- สถานะการทำความสะอาด ---
            _sectionCard(
              icon: Icons.cleaning_services_rounded,
              title: "สถานะการทำความสะอาด",
              child: _buildDropdown(),
            ),
            const SizedBox(height: 16),

            // --- ตรวจสอบความเรียบร้อย ---
            _sectionCard(
              icon: Icons.camera_alt_rounded,
              title: "ตรวจสอบความเรียบร้อย",
              child: Column(
                children: [
                  _photoItem("เตียงนอน", Icons.bed_rounded),
                  const SizedBox(height: 12),
                  _photoItem(
                      "เครื่องปรับอากาศ / อุปกรณ์ไฟฟ้า", Icons.air_rounded),
                  const SizedBox(height: 12),
                  _photoItem("ห้องน้ำ", Icons.bathtub_rounded),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- ปุ่ม ---
            Button(
              text: "บันทึกข้อมูล",
              onTap: () async {
                final success = await context
                    .read<HousekeeperRoomCheckScreenProvider>()
                    .saveRoomDetail(
                      roomNo: widget.roomNo,
                      cleaningStatus: _cleaningStatus,
                    );

                if (success) {
                  //เก็บ context ไว้ก่อน pop
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.pop(context);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text("บันทึกห้อง ${widget.roomNo} สำเร็จ"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              },
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            Button(
              text: "แจ้งชำรุด / ส่งซ่อม",
              onTap: () => _showDamageReport(context),
              color: Constants.primaryColor,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- Section Card ---
  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.white,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        border: Border.all(color: Constants.inputFieldBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Constants.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: Constants.fontSizeTitle,
                      fontWeight: Constants.fontWeightBold)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // --- Photo Item ---
  Widget _photoItem(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Mock ส่ง path ไปก่อน ค่อยเปลี่ยนเป็น image picker จริง
        const mockImagePath = "assets/images/mock_image.jpg";
        print("$label → $mockImagePath");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Constants.inputFieldBorderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: Constants.primaryColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: Constants.fontSizeBody)),
            ),
            Icon(Icons.camera_alt_outlined, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
  // Widget _photoItem(String label, IconData icon) {
  //   return GestureDetector(
  //     onTap: () {},
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[100],
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: Constants.inputFieldBorderColor),
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(icon, color: Constants.primaryColor, size: 22),
  //           const SizedBox(width: 12),
  //           Expanded(
  //             child: Text(label,
  //                 style: const TextStyle(fontSize: Constants.fontSizeBody)),
  //           ),
  //           Icon(Icons.camera_alt_outlined, color: Colors.grey[400], size: 20),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // --- Dropdown ---
  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Constants.inputFieldBorderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _cleaningStatus,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: Constants.primaryColor),
          items: [
            _dropdownItem("ยังไม่ได้ทำความสะอาด", Colors.red),
            _dropdownItem("กำลังทำความสะอาด", Constants.secondaryColor),
            _dropdownItem("ทำความสะอาดเสร็จสิ้น", Colors.green),
          ],
          onChanged: (v) => setState(() => _cleaningStatus = v!),
        ),
      ),
    );
  }

  DropdownMenuItem<String> _dropdownItem(String value, Color color) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Text(value, style: const TextStyle(fontSize: Constants.fontSizeBody)),
        ],
      ),
    );
  }

  // --- แจ้งซ่อม ---
  void _showDamageReport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Constants.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.build_rounded,
                    color: Constants.primaryColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  "แจ้งซ่อม ห้อง ${widget.roomNo}",
                  style: const TextStyle(
                      fontSize: Constants.fontSizeTitle,
                      fontWeight: Constants.fontWeightBold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            createInputField(InputFieldType.fullName,
                textLabel: "ชื่อสิ่งของที่ชำรุด"),
            createInputField(InputFieldType.specialRequest,
                textLabel: "รายละเอียดอาการชำรุด"),
            const SizedBox(height: 20),
            Button(
              text: "ส่งข้อมูลแจ้งซ่อม",
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "ส่งรายงานแจ้งซ่อมห้อง ${widget.roomNo} เรียบร้อยแล้ว"),
                    backgroundColor: Constants.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              color: Constants.primaryColor,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
