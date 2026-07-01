// check_in_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../../components/bavbar/bottomNavbar.dart';
import '../../../components/bavbar/topNavbar.dart';
import '../../../components/button/button.dart';
import '../../../core/constants.dart';
import '../../../core/form_enum.dart';
import '../../BookingFormScreen/screen/booking_form_screen_mobileBody.dart';
import '../provider/check_in_screen_provider.dart';
import '../../listPage/screen/list_screen.dart';

class CheckInScreenDesktopBody extends StatelessWidget {
  const CheckInScreenDesktopBody({super.key});

  void _handleCheckInResult(BuildContext context, CheckInStatus status) {
    if (status == CheckInStatus.success) {
      showSuccessDialog(
        context,
        "Check in แล้ว",
        "Check in สำเร็จแล้ว ตรวจสภาพห้องก่อนเข้าพัก",
        ListScreen(
            checkInStatus: true, ckeckOutStatus: false, statusConCheck: false),
        "รหัสเข้าห้อง[ 839201 ]",
        "ใช้ได้ตั้งแต่: 15 ก.พ. 14:00",
        "หมดอายุ: 17 ก.พ. 12:00",
      );
      context.read<CheckInScreenProvider>().resetStatus();
    } else if (status == CheckInStatus.error) {
      final msg = context.read<CheckInScreenProvider>().errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
      context.read<CheckInScreenProvider>().resetStatus();
    }
  }

  Future<void> _saveQRCode(BuildContext context) async {
    try {
      ByteData byteData = await rootBundle.load("assets/images/QRcodePay.png");
      Uint8List bytes = byteData.buffer.asUint8List();
      final result = await ImageGallerySaver.saveImage(bytes,
          quality: 100,
          name: "Hotel_QR_Payment_${DateTime.now().millisecondsSinceEpoch}");
      if (result['isSuccess']) {
        showSuccessSaveQRcodeDialog(context, "บันทึก QRcode แล้ว",
            "QRcode ถูกบันทึกลงในคลังรูปภาพแล้ว");
      } else {
        throw Exception("Save failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("เกิดข้อผิดพลาด: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            Topnavbar(widthFactor: 0.1),
            Expanded(
              child: Consumer<CheckInScreenProvider>(
                builder: (context, provider, _) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _handleCheckInResult(context, provider.status);
                  });

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Header ---
                            Center(
                              child: Text("เช็คอินเข้าพัก",
                                  style: TextStyle(
                                      fontSize: Constants.fontSizeHeader,
                                      fontWeight: Constants.fontWeightBold)),
                            ),
                            const SizedBox(height: 32),

                            // --- 2 คอลัมน์ ---
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- Left: ข้อมูลผู้เข้าพัก ---
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      _buildCard(
                                        title: "ข้อมูลผู้เข้าพัก",
                                        icon: Icons.person_outline,
                                        child: Column(
                                          children: [
                                            createInputField(
                                                InputFieldType.idCardNumber,
                                                controller: provider
                                                    .idCardNumberController),
                                            createInputField(
                                                InputFieldType.fullName,
                                                controller: provider
                                                    .fullNameController),
                                            createInputField(
                                              InputFieldType.gender,
                                              selectedValue: provider.gender,
                                              onChanged: (value) => provider
                                                  .setGender(value.toString()),
                                            ),
                                            createInputField(
                                                InputFieldType.address,
                                                controller:
                                                    provider.addressController),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildCard(
                                        title: "รูปบัตรประชาชน",
                                        icon: Icons.credit_card_outlined,
                                        child: createInputField(
                                          InputFieldType.idCard,
                                          imageFile: provider.idCardImage,
                                          onTap: provider.takeIdCardPhoto,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildCard(
                                        title: "ลายเซ็นยืนยัน",
                                        icon: Icons.draw_outlined,
                                        child: createInputField(
                                          InputFieldType.signature,
                                          sigController: provider.sigController,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildCard(
                                        title: "หลักฐานการชำระเงิน",
                                        icon: Icons.receipt_outlined,
                                        child: createInputField(
                                          InputFieldType.paymentSlip,
                                          imageFile: provider.paymentSlipImage,
                                          onTap: provider.pickSlipImage,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      provider.isLoading
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Button(
                                              text: "ยืนยันการเช็คอิน",
                                              onTap: () =>
                                                  provider.submitCheckIn(),
                                              color: Constants.secondaryColor,
                                            ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 24),

                                // --- Right: QR Code ---
                                Expanded(
                                  flex: 2,
                                  child: _buildCard(
                                    title: "ชำระค่าบริการ",
                                    icon: Icons.qr_code_outlined,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Constants.secondaryColor,
                                            borderRadius: BorderRadius.circular(
                                                Constants.borderRadius),
                                          ),
                                          child: Image.asset(
                                              "assets/images/QRcodePay.png"),
                                        ),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton.icon(
                                            onPressed: () =>
                                                _saveQRCode(context),
                                            icon: const Icon(Icons.download),
                                            label: const Text("บันทึก QRcode"),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  Constants.primaryColor,
                                              side: BorderSide(
                                                  color:
                                                      Constants.primaryColor),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Constants
                                                              .borderRadius)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Bottomnavbar(isVisibleHousekeeper: false),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Constants.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontSize: Constants.fontSizeTitle,
                      fontWeight: Constants.fontWeightBold,
                      color: Constants.primaryColor)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
