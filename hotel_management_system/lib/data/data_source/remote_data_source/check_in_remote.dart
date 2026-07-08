import 'dart:developer';
import 'dart:io';
import 'package:hotel_management_system/data/model/check_in_model.dart';

abstract class CheckInRemoteDataSource {
  Future<bool> getCheckInData(CheckInModel checkInData);
}

class CheckInRemoteDataSourceImpl implements CheckInRemoteDataSource {
  @override
  Future<bool> getCheckInData(CheckInModel checkInData) async {
    log(" BookingId ${checkInData.bookingId} ,idCardNumber : ${checkInData.idCardNumber} , fulName : ${checkInData.fullName} , gender : ${checkInData.gender} , address : ${checkInData.address} idCardImage : ${checkInData.idCardImage} , signatureImage : ${checkInData.signatureImage} , paymentSlipImage : ${checkInData.paymentSlipImage}");

    await Future.delayed(const Duration(seconds: 2));
    try {
      if (checkInData.idCardNumber!.isNotEmpty &&
          checkInData.fullName!.isNotEmpty &&
          checkInData.gender!.isNotEmpty &&
          checkInData.address!.isNotEmpty &&
          checkInData.idCardImage!.isNotEmpty &&
          checkInData.signatureImage!.isNotEmpty &&
          checkInData.paymentSlipImage!.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}
