// booking_form_screen_desktopBody.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/booking_form_remote.dart';
import 'package:hotel_management_system/data/repositorise/booking_form_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/booking_form_usecase.dart';
import 'package:hotel_management_system/util/widget/components/button/button.dart';
import 'package:hotel_management_system/presentation/page/BookingFormScreen/provider/Booking_form_screen_provider.dart';
import 'package:provider/provider.dart';

import '../../../../util/model/model.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/dialog/dialog_helper.dart';
import '../../../../util/widget/core/constants.dart';
import '../../../../util/widget/core/form_enum.dart';

class BookingFormScreenDesktopBody extends StatefulWidget {
  final String roomId;

  const BookingFormScreenDesktopBody({super.key, required this.roomId});

  @override
  State<BookingFormScreenDesktopBody> createState() =>
      _BookingFormScreenDesktopBodyState();
}

class _BookingFormScreenDesktopBodyState
    extends State<BookingFormScreenDesktopBody> {
  late final BookingFormScreenProvider _provider;

  @override
  void initState() {
    super.initState();
    final bookingUsecase = BookingFormUsecase(
        BookingFormRepositoriseImpl(BookingFormRemoteDataSourceImpl()));
    _provider = BookingFormScreenProvider(bookingUsecase);
    _provider.addListener(_onProviderChanged);
  }

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
    return ChangeNotifierProvider.value(
      value: _provider,
      builder: (context, _) => Scaffold(
        backgroundColor: Constants.bgcolor,
        body: SafeArea(
          child: Column(
            children: [
              Topnavbar(widthFactor: 0.1),
              Expanded(
                child: Consumer<BookingFormScreenProvider>(
                  builder: (context, provider, _) {
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
                                  'จองห้องพักหมายเลข ${widget.roomId}',
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
                                            color:
                                                Colors.black.withOpacity(0.06),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('ข้อมูลผู้จอง',
                                              style: TextStyle(
                                                  fontSize:
                                                      Constants.fontSizeTitle,
                                                  fontWeight: Constants
                                                      .fontWeightBold)),
                                          const SizedBox(height: 20),
                                          createInputField(
                                              InputFieldType.fullName,
                                              controller:
                                                  provider.fullNameController),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: createInputField(
                                                  InputFieldType.datePicker,
                                                  context: context,
                                                  controller: provider
                                                      .checkInController,
                                                  textLabel: "วันที่เช็คอิน",
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: createInputField(
                                                  InputFieldType.datePicker,
                                                  context: context,
                                                  controller: provider
                                                      .checkOutController,
                                                  textLabel: "วันที่เช็คเอาท์",
                                                ),
                                              ),
                                            ],
                                          ),
                                          createInputField(InputFieldType.email,
                                              controller:
                                                  provider.emailController),
                                          createInputField(
                                              InputFieldType.phoneNumber,
                                              controller:
                                                  provider.phoneController),
                                          createInputField(
                                              InputFieldType.numberOfGuests,
                                              controller: provider
                                                  .numberOfGuestsController),
                                          const SizedBox(height: 20),
                                          Text('หลักฐานการโอนเงิน',
                                              style: TextStyle(
                                                  fontSize:
                                                      Constants.fontSizeTitle,
                                                  fontWeight: Constants
                                                      .fontWeightBold)),
                                          const SizedBox(height: 12),
                                          createInputField(
                                            InputFieldType.paymentSlip,
                                            imageFile:
                                                provider.paymentSlipImage,
                                            onTap: provider.pickSlipImage,
                                          ),
                                          const SizedBox(height: 24),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Button(
                                              text: provider.isLoading
                                                  ? "กำลังจอง..."
                                                  : "จองห้องนี้",
                                              onTap: provider.isLoading
                                                  ? () {}
                                                  : () =>
                                                      provider.submitBooking(
                                                          roomId:
                                                              widget.roomId),
                                              color: Constants.secondaryColor,
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
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.06),
                                                blurRadius: 16,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Text('ชำระค่ามัดจำ',
                                                  style: TextStyle(
                                                      fontSize: Constants
                                                          .fontSizeTitle,
                                                      fontWeight: Constants
                                                          .fontWeightBold)),
                                              const SizedBox(height: 16),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Constants.secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Constants
                                                              .borderRadius),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/QRcodePay.png"),
                                              ),
                                              const SizedBox(height: 16),
                                              SizedBox(
                                                width: double.infinity,
                                                child: OutlinedButton.icon(
                                                  onPressed: () => provider
                                                      .saveQRCode(), // เรียก provider แทน
                                                  icon: const Icon(
                                                      Icons.download),
                                                  label: const Text(
                                                      "บันทึก QRcode"),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    foregroundColor:
                                                        Constants.primaryColor,
                                                    side: BorderSide(
                                                        color: Constants
                                                            .primaryColor),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(Constants
                                                              .borderRadius),
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
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.06),
                                                blurRadius: 16,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('ข้อมูลบัญชีธนาคาร',
                                                  style: TextStyle(
                                                      fontSize: Constants
                                                          .fontSizeTitle,
                                                      fontWeight: Constants
                                                          .fontWeightBold)),
                                              const SizedBox(height: 12),
                                              createInputField(
                                                  InputFieldType.bank,
                                                  controller:
                                                      provider.bankController),
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
