// booking_form_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/booking_form_remote.dart';
import 'package:hotel_management_system/data/repositorise/booking_form_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/booking_form_usecase.dart';
import 'package:hotel_management_system/presentation/components/button/button.dart';
import 'package:hotel_management_system/presentation/page/BookingFormScreen/provider/Booking_form_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../../components/bavbar/topNavbar.dart';
import '../../../core/constants.dart';
import '../../../core/form_enum.dart';
import '../../listPage/screen/list_screen.dart';

class BookingFormScreenMobileBody extends StatelessWidget {
  final int roomId;

  const BookingFormScreenMobileBody({super.key, required this.roomId});

  void _handleBookingResult(BuildContext context, BookingFormStatus status) {
    if (status == BookingFormStatus.success) {
      showSuccessDialog(
        context,
        "จองห้องนี้",
        "เราได้รับข้อมูลการจองห้องพักเลขที่ $roomId เรียบร้อยแล้ว",
        ListScreen(),
        "",
        "",
        "",
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
        SnackBar(
            content: Text("เกิดข้อผิดพลาด: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingUsecase = BookingFormUsecase(
      BookingFormRepositoriseImpl(BookingFormRemoteDataSourceImpl()),
    );

    return ChangeNotifierProvider(
      create: (_) => BookingFormScreenProvider(bookingUsecase),
      builder: (context, _) => Scaffold(
        backgroundColor: Constants.white,
        floatingActionButton: Consumer<BookingFormScreenProvider>(
          builder: (context, provider, _) {
            return FloatingActionButton.extended(
              onPressed: provider.isLoading
                  ? null
                  : () => provider.submitBooking(roomId),
              label: provider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("จองห้องนี้"),
            );
          },
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Consumer<BookingFormScreenProvider>(
                  builder: (context, provider, _) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _handleBookingResult(context, provider.status);
                    });
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Text(
                              'จองห้องพักหมายเลข $roomId',
                              style: TextStyle(
                                  fontSize: Constants.fontSizeHeader,
                                  fontWeight: Constants.fontWeightBold),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('กรุณากรอกข้อมูล',
                              style:
                                  TextStyle(fontSize: Constants.fontSizeBody)),
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
                          createInputField(InputFieldType.bank,
                              controller: provider.bankController),
                          createInputField(InputFieldType.phoneNumber,
                              controller: provider.phoneController),
                          createInputField(InputFieldType.numberOfGuests,
                              controller: provider.numberOfGuestsController),
                          Text("จ่ายค่ามัดจำผ่าน QR code",
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
                          Center(
                            child: GestureDetector(
                              onTap: () => _saveQRCode(context),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Constants.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      Constants.borderRadius),
                                ),
                                child: Text(
                                  "บันทึก QRcode",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Constants.fontSizeBody),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          createInputField(
                            InputFieldType.paymentSlip,
                            imageFile: provider.paymentSlipImage,
                            onTap: provider.pickSlipImage,
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Topnavbar(widthFactor: 0.2)),
              ],
            ),
          ),
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
