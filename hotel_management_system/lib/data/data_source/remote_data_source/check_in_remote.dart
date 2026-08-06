import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/check_in_model.dart';

abstract class CheckInRemoteDataSource {
  Future<bool> getCheckInData(CheckInModel checkInData);
}

class CheckInRemoteDataSourceImpl implements CheckInRemoteDataSource {
  final Dio dio;

  CheckInRemoteDataSourceImpl(this.dio);

  @override
  Future<bool> getCheckInData(CheckInModel checkInData) async {
    final response = await dio.patch(
      "bookings/${checkInData.bookingId}/checkin",
      data: {
        "idCardNumber": checkInData.idCardNumber,
        "fullName": checkInData.fullName,
        "gender": checkInData.gender,
        "address": checkInData.address,
        "idCardImage": checkInData.idCardImage,
        "signatureImage": checkInData.signatureImage,
        "paymentSlipImage": checkInData.paymentSlipImage,
      },
    );

    return response.statusCode == 200;
  }
}