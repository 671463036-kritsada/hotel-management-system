// check_in_screen.dart
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

class CheckInScreenMobileBody extends StatefulWidget {
  final int? bookingID;
  const CheckInScreenMobileBody({super.key, this.bookingID});

  @override
  State<CheckInScreenMobileBody> createState() =>
      _CheckInScreenMobileBodyState();
}

class _CheckInScreenMobileBodyState extends State<CheckInScreenMobileBody> {
  late final CheckInScreenProvider _provider;

  @override
  void initState() {
    super.initState();
    final checkInUsecase =
        CheckInUsecase(CheckInRepositoriseImpl(CheckInRemoteDataSourceImpl()));
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Consumer<CheckInScreenProvider>(
                builder: (context, provider, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(Constants.padding),
                        child: Column(
                          children: [
                            const SizedBox(height: 100),
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
                            Text('รูปบัตรประชาชน',
                                style: TextStyle(
                                    fontSize: Constants.fontSizeBody)),
                            createInputField(
                              InputFieldType.idCard,
                              imageFile: provider.idCardImage,
                              onTap: provider.takeIdCardPhoto,
                            ),
                            const SizedBox(height: 20),
                            Text('ลายเซ็นยืนยัน',
                                style: TextStyle(
                                    fontSize: Constants.fontSizeBody)),
                            createInputField(InputFieldType.signature,
                                sigController: provider.sigController),
                            Text("จ่ายเงิน",
                                style: TextStyle(
                                    fontSize: Constants.fontSizeBody)),
                            Center(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Constants.secondaryColor,
                                  borderRadius: BorderRadius.circular(
                                      Constants.borderRadius),
                                ),
                                child:
                                    Image.asset("assets/images/QRcodePay.png"),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () =>
                                  provider.saveQRCode(),
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
                            Text("หลักฐานการชำระเงิน",
                                style: TextStyle(
                                    fontSize: Constants.fontSizeBody)),
                            const SizedBox(height: 10),
                            createInputField(
                              InputFieldType.paymentSlip,
                              imageFile: provider.paymentSlipImage,
                              onTap: provider.pickSlipImage,
                            ),
                            const SizedBox(height: 20),
                            provider.isLoading
                                ? const CircularProgressIndicator()
                                : Button(
                                    text: "ตกลง",
                                    onTap: () => provider
                                        .submitCheckIn(widget.bookingID ?? 0),
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
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Topnavbar(widthFactor: 0.2)),
              Positioned(bottom: 0, right: 0, left: 0, child: Bottomnavbar()),
            ],
          ),
        ),
      ),
    );
  }
}