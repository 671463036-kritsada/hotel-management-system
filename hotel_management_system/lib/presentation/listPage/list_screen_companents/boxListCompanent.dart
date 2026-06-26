import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/RoomConditionCheckPage/room_condition_check_screen.dart';

import 'package:hotel_management_system/presentation/listPage/list_screen.dart';

import '../../components/button/button.dart';
import '../../core/constants.dart';

class Boxlistcompanent extends StatelessWidget {
  final int roomNumber;
  final String date, payamout, keyBooking, status, textStatus;
  final Color statusColor;
  final bool? statusChekin;
  final bool? statusCheckout;
  final bool? statusConCheck;

  final Function()? onTap;

  Boxlistcompanent(
      {super.key,
      required this.roomNumber,
      required this.date,
      required this.payamout,
      required this.keyBooking,
      required this.status,
      required this.textStatus,
      required this.statusColor,
      required this.onTap,
      required this.statusChekin,
      this.statusCheckout,
      this.statusConCheck});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 0))
            ],
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ห้อง $roomNumber"),
                  Text("วันที่เข้า"),
                  Text("ยอดชำระ"),
                  Text("รหัสการจอง"),
                  if (statusChekin == true) Text("รหัสเข้าห้อง")
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 23,
                  ),
                  Text(date),
                  Text(payamout),
                  Text(keyBooking),
                  Text(statusChekin == true ? "839201" : ""),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 15,
                          color: statusColor,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          status,
                          style: TextStyle(
                              color: statusColor,
                              fontSize: Constants.fontSizeBody),
                        ),
                      ],
                    ),
                    Text(
                      textStatus,
                      style: TextStyle(
                          color: statusColor, fontSize: Constants.fontSizeBody),
                    ),
                    if (statusChekin == true && statusConCheck == false)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomConditionCheckScreen(),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          padding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius),
                          ),
                          child: Text(
                            "ตรวจสภาพห้อง",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Constants.fontSizeBody),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (statusChekin == true)
                      Button(
                        text: "เช็คเอาท์",
                        onTap: () {
                          if (statusCheckout == true) return;

                          // 1. ถามยืนยันการเช็คเอาท์ก่อน
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
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
                                      backgroundColor: Constants.secondaryColor,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // ปิด Dialog ยืนยัน
                                      _showFeedbackDialog(
                                          context); // 2. ไปที่หน้าให้ดาวและความเห็น
                                    },
                                    child: const Text('ยืนยัน'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        color: Colors.red,
                        btnSize: 150,
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
