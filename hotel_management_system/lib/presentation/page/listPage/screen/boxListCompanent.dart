import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/RoomConditionCheckPage/screen/room_condition_check_screen.dart';

import 'package:hotel_management_system/presentation/page/listPage/screen/list_screen.dart';
import '../../../core/constants.dart';

class Boxlistcompanent extends StatelessWidget {
  final int roomNumber;
  final String status, textStatus;
  final int keyBooking;
  final double payamout;
  final Color statusColor;
  final bool? statusChekin;
  final bool? statusCheckout;
  final bool? statusConCheck;
  final String? roomKey;

  final Function()? onTap;

  Boxlistcompanent(
      {super.key,
      required this.roomNumber,
      required this.payamout,
      required this.keyBooking,
      required this.status,
      required this.textStatus,
      required this.statusColor,
      required this.onTap,
      required this.statusChekin,
      this.statusCheckout,
      this.statusConCheck,
      this.roomKey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            // --- Header: ห้องและสถานะ ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.07),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.meeting_room_outlined,
                          color: Constants.primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text("ห้อง $roomNumber",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: statusColor),
                        const SizedBox(width: 6),
                        Text(status,
                            style: TextStyle(
                                color: statusColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Body: ข้อมูล ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.payments_outlined, "ยอดชำระ",
                      "฿${payamout.toStringAsFixed(2)}"),
                  _buildInfoRow(Icons.confirmation_number_outlined,
                      "รหัสการจอง", keyBooking),
                  if (statusChekin == true) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.key_outlined, "รหัสเข้าห้อง", "839201"),
                  ],
                  if (textStatus.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.info_outline, "สถานะ", textStatus,
                        color: statusColor),
                  ],
                  if (roomKey != "") ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.key, "รหัสเข้าห้อง", roomKey,
                        color: statusColor),
                  ]
                ],
              ),
            ),

            // --- Footer: ปุ่ม action ---
            if (statusChekin == true)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    if (statusConCheck == true)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RoomConditionCheckScreen()),
                          ),
                          icon: const Icon(Icons.checklist_outlined, size: 18),
                          label: const Text("ตรวจสภาพห้อง"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    if (statusConCheck == true) const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (statusCheckout == true) return;
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                title: const Text('ยืนยันการเช็คเอาท์'),
                                content: const Text(
                                    'คุณแน่ใจว่าต้องการเช็คเอาท์หรือไม่?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('ยกเลิก'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Constants.secondaryColor),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _showFeedbackDialog(context);
                                    },
                                    child: const Text('ยืนยัน'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text("เช็คเอาท์"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, dynamic value,
      {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Text("$label  ",
            style: TextStyle(fontSize: 13, color: Colors.grey[500])),
        Expanded(
          child: Text(value.toString(),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color ?? Colors.grey[800]),
              textAlign: TextAlign.end),
        ),
      ],
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    double selectedRating = 0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // ใช้ StatefulBuilder เพื่อให้กดเลือกดาวแล้ว UI เปลี่ยนทันที
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title:
                  const Text('คะแนนความพึงพอใจ', textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('ความพึงพอใจต่อการเข้าพักของคุณ'),
                  const SizedBox(height: 15),
                  // แถวของดาว (Rating Stars)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 35,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'แสดงความคิดเห็นเพิ่มเติม...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => {
                    Navigator.of(context).pop(), // ปิด Dialog
                    _showSuccessDialog(context)
                  },
                  child: const Text('ข้าม'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    // ตรงนี้คุณสามารถนำ selectedRating และ commentController.text ไปบันทึกลง Database ได้
                    Navigator.of(context).pop(); // ปิดหน้า Feedback
                    _showSuccessDialog(context); // 3. แสดงหน้าสำเร็จ
                  },
                  child: const Text('ส่งความเห็น'),
                ),
              ],
            );
          },
        );
      },
    );
  }

// ฟังก์ชันสุดท้ายแจ้งเตือนสำเร็จ
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เช็คเอาท์สำเร็จ'),
          content:
              const Text('คุณได้เช็คเอาท์เรียบร้อยแล้ว ขอบคุณที่ใช้บริการ'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.secondaryColor),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListScreen(
                      checkInStatus: true,
                      ckeckOutStatus: true,
                    ),
                  ),
                );
              },
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }
}
