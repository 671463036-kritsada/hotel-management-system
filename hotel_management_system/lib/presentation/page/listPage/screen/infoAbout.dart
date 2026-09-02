import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/checkInPage/screen/check_in_screen.dart';
import 'package:hotel_management_system/util/widget/core/network/dio_client.dart';

import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';

class Infoabout extends StatelessWidget {
  final bool? checkInStatus;
  final String? status;
  final String? bookingId;
  final String? customerName;
  final String? phone;
  final String? email;
  final String? roomId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? roomsCount;
  final int? personCount;
  final String? slipUrl;
  final double? remainingAmount; // เพิ่ม
  final String? roomKey;

  Infoabout({
    super.key,
    this.bookingId,
    this.status,
    this.checkInStatus,
    this.customerName,
    this.phone,
    this.email,
    this.roomId,
    this.checkIn,
    this.checkOut,
    this.roomsCount,
    this.personCount,
    this.slipUrl,
    this.remainingAmount,
    this.roomKey, // เพิ่ม
  });

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return "-";
    const thaiMonths = [
      '',
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.'
    ];
    final buddhistYear = end.year + 543;
    return "${start.day}-${end.day} ${thaiMonths[end.month]} $buddhistYear";
  }

  int _calculateNights(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 0;
    return end.difference(start).inDays;
  }

  // ดึง root URL จาก DioClient (ตัด "/api/" ท้าย baseUrl ออก)
  String get _serverRootUrl {
    final apiBaseUrl =
        DioClient.dio.options.baseUrl; // "http://localhost:2000/api/"
    return apiBaseUrl.replaceFirst(
        RegExp(r'/api/?$'), ''); // -> "http://localhost:2000"
  }

  Widget _buildSlipImage() {
    if (slipUrl == null || slipUrl!.isEmpty) {
      return Image.asset("assets/images/QRcodePay.png");
    }

    if (slipUrl!.startsWith("assets/")) {
      return Image.asset(slipUrl!);
    }

    final fullUrl = "$_serverRootUrl/$slipUrl";
    return Image.network(
      fullUrl,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset("assets/images/QRcodePay.png");
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

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
            _infoRow("ชื่อ-นามสกุล", customerName ?? "-", null),
            _infoRow("เบอร์โทร", phone ?? "-", null),
            _infoRow("Email", email ?? "-", null),
            const SizedBox(height: 20),
            _infoRow("เลขห้อง", roomId ?? "-", null),
            _infoRow(
                "วันที่เข้าพัก", _formatDateRange(checkIn, checkOut), null),
            _infoRow("จำนวนคืน", _calculateNights(checkIn, checkOut).toString(),
                null),
            _infoRow("จำนวนคน", (personCount ?? 0).toString(), null),
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
              child: _buildSlipImage(),
            ),
            if (checkInStatus == true)
              Text("รหัสเข้าห้อง: ${roomKey}",
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
                      builder: (context) => CheckInScreen(
                        bookingId: bookingId,
                        totalPrice: remainingAmount ??
                            0, // เพิ่ม: ส่ง remaining_amount ตรงๆ
                        depositAmount:
                            0, // เพิ่ม: ไม่ต้องหักซ้ำเพราะ remaining_amount หักมัดจำมาแล้ว
                      ),
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
