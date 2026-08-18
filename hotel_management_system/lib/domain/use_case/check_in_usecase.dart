import 'dart:io';

import 'package:hotel_management_system/data/model/check_in_model.dart';
import 'package:hotel_management_system/data/repositorise/check_in_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/check_in_entitise.dart';

class CheckInUsecase {
  final CheckInRepositoriseImpl repository;
  CheckInUsecase(this.repository);

  Future<bool> getCheckInData(CheckInEntitise checkInData) async {
    try {
      final checkInDataModel = CheckInModel(
          bookingId: checkInData.bookingId,
          idCardNumber: checkInData.idCardNumber,
          fullName: checkInData.fullName,
          gender: checkInData.gender,
          address: checkInData.address,
          idCardImage: checkInData.idCardImage,
          signatureImage: checkInData.signatureImage,
          paymentSlipImage: checkInData.paymentSlipImage,
          paymentStatus: "PAID");

      return await repository.getCheckInData(checkInDataModel);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}
