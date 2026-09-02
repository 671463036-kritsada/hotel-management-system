// check_in_screen.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/check_in_remote.dart';
import 'package:hotel_management_system/data/repositorise/check_in_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/check_in_usecase.dart';
import 'package:hotel_management_system/util/widget/core/network/dio_client.dart';
import 'package:provider/provider.dart';

import '../../../../data/data_source/remote_data_source/promotion_remote.dart';
import '../../../../data/repositorise/promotion_repositorise.dart';
import '../../../../domain/use_case/promotion_usecase.dart';
import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../../../../util/widget/core/form_enum.dart';
import '../provider/check_in_screen_provider.dart';
import '../../../../util/widget/components/dialog/dialog_helper.dart';

class CheckInScreenMobileBody extends StatefulWidget {
  final String? bookingID;
  final double totalPrice; // เพิ่มใหม่: ราคาค่าเช่าซื้อทั้งหมด (ก่อนหักใดๆ)
  final double depositAmount; // เพิ่มใหม่: ค่าหมัดจำที่ชำระไปแล้ว

  const CheckInScreenMobileBody({
    super.key,
    this.bookingID,
    this.totalPrice = 0,
    this.depositAmount = 0,
  });

  @override
  State<CheckInScreenMobileBody> createState() =>
      _CheckInScreenMobileBodyState();
}

class _CheckInScreenMobileBodyState extends State<CheckInScreenMobileBody> {
  late final CheckInScreenProvider _provider;

  @override
  void initState() {
    super.initState();
    final checkInUsecase = CheckInUsecase(
        CheckInRepositoriseImpl(CheckInRemoteDataSourceImpl(DioClient.dio)));
    final promotionUsecase = PromotionUsecase(// เพิ่ม
        PromotionRepositoriseImpl(
            PromotionRemoteDataSourceImpl(DioClient.dio)));
    _provider = CheckInScreenProvider(
        checkInUsecase, promotionUsecase); // แก้: เพิ่ม param
    _provider.addListener(_onProviderChanged);
    _provider.setPricing(
      totalPrice: widget.totalPrice,
      depositAmount: widget.depositAmount,
    );
    _provider.loadCoupons(); // เพิ่ม: โหลดคูปองจริงตอนเปิดหน้า
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
        "",
        "",
        "",
        // arguments: ListScreenArguments(
        //   checkInStatus: true,
        //   ckeckOutStatus: false,
        //   statusConCheck: false,
        // ),
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

  ///format ตัวเลขเป็นสกุลเงินบาท
  String _formatBaht(double value) {
    return "${value.toStringAsFixed(2)} บาท";
  }

  ///widget แถวสรุปราคาแต่ละบรรทัด
  Widget _priceRow(String label, double amount, {bool isTotal = false}) {
    final style = TextStyle(
      fontSize: isTotal ? Constants.fontSizeBody : Constants.fontSizeBody - 2,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: amount < 0 ? Colors.red[400] : Colors.black87,
    );
    final displayAmount =
        amount < 0 ? "-${_formatBaht(amount.abs())}" : _formatBaht(amount);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // เพิ่ม: กันข้อความสองบรรทัดเยื้องกัน
        children: [
          Expanded(
            // เพิ่ม: ให้ label บีบตัวและ wrap แทนการดันจำนวนเงินออกจอ
            child: Text(label, style: style),
          ),
          const SizedBox(
              width: 8), // เพิ่ม: กันข้อความชนกันตอน label ยาวจนเกือบเต็มบรรทัด
          Text(displayAmount, style: style),
        ],
      ),
    );
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
                            const SizedBox(height: 20),

                            // ================= เพิ่มใหม่: คูปองส่วนลด =================
                            Text('คูปองส่วนลด',
                                style: TextStyle(
                                    fontSize: Constants.fontSizeBody)),
                            const SizedBox(height: 8),
                            if (provider.couponLoadStatus ==
                                CouponLoadStatus.loading)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            else if (provider.couponLoadStatus ==
                                CouponLoadStatus.error)
                              Text(provider.couponLoadError,
                                  style: const TextStyle(color: Colors.red))
                            else if (provider.coupons.isEmpty)
                              Text("ไม่มีคูปองที่ใช้ได้ในขณะนี้",
                                  style: TextStyle(color: Colors.grey[500]))
                            else
                              Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Constants.borderRadius),
                                  side: BorderSide(color: Colors.grey[300]!),
                                ),
                                child: Column(
                                  children: [
                                    RadioListTile<int?>(
                                      value: null,
                                      groupValue: provider
                                          .selectedCoupon?.userPromotionId,
                                      title: const Text("ไม่ใช้คูปอง"),
                                      onChanged: (value) =>
                                          provider.selectCoupon(null),
                                    ),
                                    ...provider.coupons.map((coupon) {
                                      return RadioListTile<int?>(
                                        value: coupon.userPromotionId,
                                        groupValue: provider
                                            .selectedCoupon?.userPromotionId,
                                        title: Text(coupon.title),
                                        subtitle: Text(coupon.code),
                                        onChanged: (value) =>
                                            provider.selectCoupon(value),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 20),
                            // สรุปค่าใช้จ่าย =================
                            Text('สรุปค่าใช้จ่าย',
                                style: TextStyle(
                                    fontSize: Constants.fontSizeBody,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(
                                    Constants.borderRadius),
                              ),
                              child: Column(
                                children: [
                                  _priceRow("ค่าเช่าซื้อทั้งหมด",
                                      provider.totalPrice),
                                  _priceRow(
                                      "หัก ค่าหมัดจำ", -provider.depositAmount),
                                  if (provider.discountAmount > 0)
                                    _priceRow(
                                      "หัก ส่วนลดคูปอง (${provider.selectedCoupon?.title ?? ''})", // แก้
                                      -provider.discountAmount,
                                    ),
                                  const Divider(height: 24),
                                  _priceRow(
                                    "ยอดที่ต้องชำระ",
                                    provider.amountDue,
                                    isTotal: true,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

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
                              onTap: () => provider.saveQRCode(),
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
                                    onTap: () {
                                      if (widget.bookingID == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text("ไม่พบข้อมูลการจอง")),
                                        );
                                        return;
                                      }
                                      provider.submitCheckIn(widget.bookingID!);
                                    },
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
