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
import '../provider/check_in_screen_provider.dart';
import '../../listPage/screen/list_screen.dart';

class CheckInScreenMobileBody extends StatelessWidget {
  const CheckInScreenMobileBody({super.key});

  void _handleCheckInResult(BuildContext context, CheckInStatus status) {
    if (status == CheckInStatus.success) {
      showSuccessDialog(
        context,
        "Check in แล้ว",
        "Check in สำเร็จแล้ว ตรวจสภาพห้องก่อนเข้าพัก",
        ListScreen(
          checkInStatus: true,
          ckeckOutStatus: false,
          statusConCheck: false,
        ),
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
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: "Hotel_QR_Payment_${DateTime.now().millisecondsSinceEpoch}",
      );
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<CheckInScreenProvider>(
              builder: (context, provider, _) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _handleCheckInResult(context, provider.status);
                });

                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(Constants.padding),
                      child: Column(
                        children: [
                          const SizedBox(height: 100),

                          // --- Input Fields ---
                          createInputField(InputFieldType.idCardNumber,
                              controller: provider.idCardNumberController),
                          createInputField(InputFieldType.fullName,
                              controller: provider.fullNameController),
                          createInputField(
                            InputFieldType.gender,
                            selectedValue: provider.gender,
                            onChanged: (value) =>
                                provider.setGender(value.toString()),
                          ),
                          createInputField(InputFieldType.address,
                              controller: provider.addressController),

                          // --- ID Card Image ---
                          Text('รูปบัตรประชาชน',
                              style:
                                  TextStyle(fontSize: Constants.fontSizeBody)),
                          createInputField(
                            InputFieldType.idCard,
                            imageFile: provider.idCardImage,
                            onTap: provider.takeIdCardPhoto,
                          ),
                          const SizedBox(height: 20),

                          // --- Signature ---
                          Text('ลายเซ็นยืนยัน',
                              style:
                                  TextStyle(fontSize: Constants.fontSizeBody)),
                          createInputField(InputFieldType.signature,
                              sigController: provider.sigController),

                          // --- QR Code Payment ---
                          Text("จ่ายเงิน",
                              style:
                                  TextStyle(fontSize: Constants.fontSizeBody)),
                          Center(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Constants.secondaryColor,
                                borderRadius: BorderRadius.circular(
                                    Constants.borderRadius),
                              ),
                              child: Image.asset("assets/images/QRcodePay.png"),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () => _saveQRCode(context),
                            child: Center(
                              child: Text(
                                "บันทึก QRcode",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: Constants.fontSizeBody,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // --- Payment Slip ---
                          Text("หลักฐานการชำระเงิน",
                              style:
                                  TextStyle(fontSize: Constants.fontSizeBody)),
                          const SizedBox(height: 10),
                          createInputField(
                            InputFieldType.paymentSlip,
                            imageFile: provider.paymentSlipImage,
                            onTap: provider.pickSlipImage,
                          ),
                          const SizedBox(height: 20),

                          // --- Submit Button ---
                          provider.isLoading
                              ? const CircularProgressIndicator()
                              : Button(
                                  text: "ตกลง",
                                  onTap: () => provider.submitCheckIn(),
                                  color: Constants.secondaryColor,
                                ),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
                top: 0, right: 0, left: 0, child: Topnavbar(widthFactor: 0.2)),
            Positioned(bottom: 0, right: 0, left: 0, child: Bottomnavbar()),
          ],
        ),
      ),
    );
  }
}

void showSuccessSaveQRcodeDialog(
    BuildContext context, String textTitle, String textBody) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text(textTitle,
                  style: TextStyle(
                      fontSize: Constants.fontSizeTitle,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(textBody,
                  style: TextStyle(
                      fontSize: Constants.fontSizeBody,
                      color: Colors.grey[700]),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('ตกลง',
                      style: TextStyle(
                          fontSize: Constants.fontSizeBody,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
