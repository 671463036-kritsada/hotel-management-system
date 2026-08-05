// booking_form_screen_mobileBody.dart
import 'package:flutter/material.dart';
// import 'package:hotel_management_system/data/data_source/remote_data_source/booking_form_remote.dart';
// import 'package:hotel_management_system/data/repositorise/booking_form_repositorise.dart';
// import 'package:hotel_management_system/domain/use_case/booking_form_usecase.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../../util/model/model.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/dialog/dialog_helper.dart';
import '../../../../util/widget/core/constants.dart';
import '../../../../util/widget/core/form_enum.dart';
import '../provider/booking_form_provider_route.dart';

class BookingFormScreenMobileBody extends StatefulWidget {
  final String roomId;

  const BookingFormScreenMobileBody({super.key, required this.roomId});

  @override
  State<BookingFormScreenMobileBody> createState() =>
      _BookingFormScreenMobileBodyState();
}

class _BookingFormScreenMobileBodyState
    extends State<BookingFormScreenMobileBody> {
  late final BookingFormScreenProvider _provider;

  // @override
  // void initState() {
  //   super.initState();
  //   final bookingUsecase = BookingFormUsecase(
  //     BookingFormRepositoriseImpl(BookingFormRemoteDataSourceImpl()),
  //   );
  //   _provider = BookingFormScreenProvider(bookingUsecase);
  //   _provider.addListener(_onProviderChanged);
  // }

  @override
  void dispose() {
    _provider.removeListener(_onProviderChanged);
    _provider.dispose();
    super.dispose();
  }

  void _onProviderChanged() {
    _handleBookingResult();
    _handleSaveQRResult();
  }

  void _handleBookingResult() {
    if (_provider.status == BookingFormStatus.success) {
      showSuccessDialog(
        context,
        "จองห้องนี้",
        "เราได้รับข้อมูลการจองห้องพักเลขที่ ${widget.roomId} เรียบร้อยแล้ว",
        "/list_page", // เปลี่ยนจาก ListScreen()
        "",
        "",
        "",
        arguments: ListScreenArguments(
          checkInStatus: false,
          ckeckOutStatus: false,
          statusConCheck: false,
        ),
      );
      _provider.resetStatus();
    } else if (_provider.status == BookingFormStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_provider.errorMessage), backgroundColor: Colors.red),
      );
      _provider.resetStatus();
    }
  }

  void _handleSaveQRResult() {
    if (_provider.saveQRStatus == SaveQRStatus.success) {
      showSuccessSaveQRcodeDialog(
          context, "บันทึก QRcode แล้ว", "QRcode ถูกบันทึกลงในคลังรูปภาพแล้ว");
      _provider.resetSaveQRStatus();
    } else if (_provider.saveQRStatus == SaveQRStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_provider.saveQRErrorMessage),
            backgroundColor: Colors.red),
      );
      _provider.resetSaveQRStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return ChangeNotifierProvider.value(
      value: _provider,
      builder: (context, _) => Scaffold(
        backgroundColor: Constants.white,
        floatingActionButton: Consumer<BookingFormScreenProvider>(
          builder: (context, provider, _) {
            return FloatingActionButton.extended(
              onPressed: provider.isLoading
                  ? null
                  : () => provider.submitBooking(roomId: widget.roomId),
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
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Text(
                              'จองห้องพักหมายเลข ${widget.roomId}',
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
                              onTap: () =>
                                  provider.saveQRCode(), // เรียก provider แทน
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
                    child: Topnavbar(widthFactor: 0.2, username: user?.name)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
