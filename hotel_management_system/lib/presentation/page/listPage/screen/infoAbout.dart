import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/checkInPage/screen/check_in_screen.dart';

import '../../../components/button/button.dart';
import '../../../core/constants.dart';

class Infoabout extends StatelessWidget {
  final bool? checkInStatus;
  final String? status;
  final int? bookingId;
  Infoabout({super.key, this.bookingId, this.status, this.checkInStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  status == "APPROVED"
                      ? "รายละเอียดการเข้าพัก"
                      : "รายละเอียดการจอง",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 30),
            _infoRow("ชื่อ-นามสกุล", "นาย สมชาย สมหวัง", null),
            _infoRow("เบอร์โทร", "090-909-9900", null),
            _infoRow("Email", "test@gmail.com", null),
            const SizedBox(height: 20),
            _infoRow("เลขห้อง", "305", null),
            _infoRow("วันที่เข้าพัก", "15-17 ก.พ. 2569", null),
            _infoRow("จำนวนคืน", "2", null),
            _infoRow("จำนวนคน", "2", null),
            // if (status == true) _infoRow("เงินทั้งหมด", "2,000 บาท", null),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "สถานะการชำระเงิน ${status == "APPROVED" ? "" : "มัดจำ"} ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Container(
              width: double.infinity,
              child: Image.asset("assets/images/slip.png"),
            ),

            if (checkInStatus == true)
              Text("รหัสเข้าห้อง: 839201",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),

            SizedBox(
              height: 20,
            ),
            if (status == "APPROVED")
              Button(
                text: "Check-in",
                onTap: () {
                  if (bookingId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("ไม่พบข้อมูลการจอง")),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckInScreen(bookingId: bookingId),
                    ),
                  );
                },
                color: Colors.green,
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Widget ช่วยจัดบรรทัดให้ตรงกัน

Widget _infoRow(String label, String value, Color? textColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey[700], fontSize: Constants.fontSizeBody)),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Constants.fontSizeBody,
                color: textColor),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
