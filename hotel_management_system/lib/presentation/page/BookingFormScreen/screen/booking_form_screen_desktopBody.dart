// booking_form_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_management_system/presentation/components/button/button.dart';
import 'package:hotel_management_system/presentation/page/BookingFormScreen/screen/booking_form_screen_mobileBody.dart';
import 'package:hotel_management_system/presentation/page/BookingFormScreen/provider/Booking_form_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../../components/bavbar/topNavbar.dart';
import '../../../core/constants.dart';
import '../../../core/form_enum.dart';
import '../../listPage/screen/list_screen.dart';

class BookingFormScreenDesktopBody extends StatelessWidget {
  final int roomId;

  const BookingFormScreenDesktopBody({super.key, required this.roomId});

  void _handleBookingResult(BuildContext context, BookingFormStatus status) {
    if (status == BookingFormStatus.success) {
      showSuccessDialog(
        context,
        "จองห้องนี้",
        "เราได้รับข้อมูลการจองห้องพักเลขที่ $roomId เรียบร้อยแล้ว",
        ListScreen(),
        "", "", "",
      );
      context.read<BookingFormScreenProvider>().resetStatus();
    } else if (status == BookingFormStatus.error) {
      final msg = context.read<BookingFormScreenProvider>().errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
      context.read<BookingFormScreenProvider>().resetStatus();
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
        SnackBar(content: Text("เกิดข้อผิดพลาด: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingFormScreenProvider(),
      builder: (context, _) => Scaffold(
        backgroundColor: Constants.bgcolor,
        body: SafeArea(
          child: Column(
            children: [
              Topnavbar( widthFactor: 0.1),
              Expanded(
                child: Consumer<BookingFormScreenProvider>(
                  builder: (context, provider, _) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _handleBookingResult(context, provider.status);
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
                                child: Text(
                                  'จองห้องพักหมายเลข $roomId',
                                  style: TextStyle(
                                      fontSize: Constants.fontSizeHeader,
                                      fontWeight: Constants.fontWeightBold),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // --- 2 คอลัมน์ ---
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // --- Left: ฟอร์ม ---
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.all(28),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.06),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('ข้อมูลผู้จอง',
                                              style: TextStyle(
                                                  fontSize: Constants.fontSizeTitle,
                                                  fontWeight: Constants.fontWeightBold)),
                                          const SizedBox(height: 20),
                                          createInputField(InputFieldType.fullName,
                                              controller: provider.fullNameController),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: createInputField(
                                                  InputFieldType.datePicker,
                                                  context: context,
                                                  controller: provider.checkInController,
                                                  textLabel: "วันที่เช็คอิน",
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: createInputField(
                                                  InputFieldType.datePicker,
                                                  context: context,
                                                  controller: provider.checkOutController,
                                                  textLabel: "วันที่เช็คเอาท์",
                                                ),
                                              ),
                                            ],
                                          ),
                                          createInputField(InputFieldType.email,
                                              controller: provider.emailController),
                                          createInputField(InputFieldType.phoneNumber,
                                              controller: provider.phoneController),
                                          createInputField(InputFieldType.numberOfGuests,
                                              controller: provider.numberOfGuestsController),
                                          const SizedBox(height: 20),
                                          Text('หลักฐานการโอนเงิน',
                                              style: TextStyle(
                                                  fontSize: Constants.fontSizeTitle,
                                                  fontWeight: Constants.fontWeightBold)),
                                          const SizedBox(height: 12),
                                          createInputField(
                                            InputFieldType.paymentSlip,
                                            imageFile: provider.paymentSlipImage,
                                            onTap: provider.pickSlipImage,
                                          ),
                                          const SizedBox(height: 24),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Consumer<BookingFormScreenProvider>(
                                              builder: (context, provider, _) {
                                                return Button(
                                                  text: provider.isLoading ? "กำลังจอง..." : "จองห้องนี้",
                                                  onTap: provider.isLoading
                                                      ? () {}
                                                      : () => provider.submitBooking(roomId),
                                                  color: Constants.secondaryColor,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 24),

                                  // --- Right: QR + ข้อมูลธนาคาร ---
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.06),
                                                blurRadius: 16,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Text('ชำระค่ามัดจำ',
                                                  style: TextStyle(
                                                      fontSize: Constants.fontSizeTitle,
                                                      fontWeight: Constants.fontWeightBold)),
                                              const SizedBox(height: 16),
                                              Container(
                                                padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: Constants.secondaryColor,
                                                  borderRadius: BorderRadius.circular(Constants.borderRadius),
                                                ),
                                                child: Image.asset("assets/images/QRcodePay.png"),
                                              ),
                                              const SizedBox(height: 16),
                                              SizedBox(
                                                width: double.infinity,
                                                child: OutlinedButton.icon(
                                                  onPressed: () => _saveQRCode(context),
                                                  icon: const Icon(Icons.download),
                                                  label: const Text("บันทึก QRcode"),
                                                  style: OutlinedButton.styleFrom(
                                                    foregroundColor: Constants.primaryColor,
                                                    side: BorderSide(color: Constants.primaryColor),
                                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(Constants.borderRadius),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 16),

                                        // --- ข้อมูลธนาคาร ---
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.06),
                                                blurRadius: 16,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('ข้อมูลบัญชีธนาคาร',
                                                  style: TextStyle(
                                                      fontSize: Constants.fontSizeTitle,
                                                      fontWeight: Constants.fontWeightBold)),
                                              const SizedBox(height: 12),
                                              createInputField(InputFieldType.bank,
                                                  controller: provider.bankController),
                                            ],
                                          ),
                                        ),
                                      ],
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
            ],
          ),
        ),
      ),
    );
  }
}
