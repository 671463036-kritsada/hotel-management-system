// check_in_screen_desktop_body.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/check_in_remote.dart';
import 'package:hotel_management_system/data/repositorise/check_in_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/check_in_usecase.dart';
import 'package:provider/provider.dart';

import '../../../../util/model/model.dart';
import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../../../../util/widget/core/form_enum.dart';
import '../provider/check_in_screen_provider.dart';
import '../../../../util/widget/components/dialog/dialog_helper.dart';

class CheckInScreenDesktopBody extends StatefulWidget {
  final int? bookingID;
  const CheckInScreenDesktopBody({super.key, this.bookingID});

  @override
  State<CheckInScreenDesktopBody> createState() =>
      _CheckInScreenDesktopBodyState();
}

class _CheckInScreenDesktopBodyState extends State<CheckInScreenDesktopBody> {
  late final CheckInScreenProvider _provider;

  @override
  void initState() {
    super.initState();
    final checkInUsecase = CheckInUsecase(
        CheckInRepositoriseImpl(CheckInRemoteDataSourceImpl()));
    _provider = CheckInScreenProvider(checkInUsecase);
    _provider.addListener(_onProviderChanged);
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderChanged);
    _provider.dispose();
    super.dispose();
  }

  void _onProviderChanged() {
    _handleCheckInResult();
    _handleSaveQRResult();
  }

  void _handleCheckInResult() {
  if (_provider.status == CheckInStatus.success) {
    showSuccessDialog(
      context,
      "Check in แล้ว",
      "Check in สำเร็จแล้ว ตรวจสภาพห้องก่อนเข้าพัก",
      "/list_page",
      "รหัสเข้าห้อง[ 839201 ]",
      "ใช้ได้ตั้งแต่: 15 ก.พ. 14:00",
      "หมดอายุ: 17 ก.พ. 12:00",
      arguments: ListScreenArguments(
        checkInStatus: true,
        ckeckOutStatus: false,
        statusConCheck: false,
      ),
    );
    _provider.resetStatus();
  } else if (_provider.status == CheckInStatus.error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_provider.errorMessage), backgroundColor: Colors.red),
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
        backgroundColor: const Color(0xFFF5F6FA),
        body: SafeArea(
          child: Column(
            children: [
              Topnavbar(widthFactor: 0.1),
              Expanded(
                child: Consumer<CheckInScreenProvider>(
                  builder: (context, provider, _) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text("เช็คอินเข้าพัก",
                                    style: TextStyle(
                                        fontSize: Constants.fontSizeHeader,
                                        fontWeight: Constants.fontWeightBold)),
                              ),
                              const SizedBox(height: 32),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                                onTap: () => provider
                                                    .submitCheckIn(widget.bookingID ?? 0),
                                                color: Constants.secondaryColor,
                                              ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
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
                                                  provider.saveQRCode(),
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