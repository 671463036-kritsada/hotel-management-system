import 'dart:io';

import 'package:hotel_management_system/data/model/responseModelRemote/response_model.dart';

abstract class ListRemoteDatasource {
  Future<List<Map<String, dynamic>>> getListData(int userID);
}

class ListRemoteDatasourceImpl implements ListRemoteDatasource {
  @override
  Future<List<Map<String, dynamic>>> getListData(int userID) async {
    final dataMock = {
      "message": "success",
      "statusCode": 200,
      "data": [
        {
          "bookingId": 1,
          "bookingCode": "BK-10111223",
          "roomNumber": 205,
          "roomKey": "839201",
          "checkInDate": "2026-02-15",
          "checkOutDate": "2026-02-17",
          "totalPrice": 1000,
          "bookingStatus": "APPROVED",
          "paymentStatus": "PAID",
          "checkInStatus": "NOT_CHECKED_IN",
          "checkOutStatus": "NOT_CHECKED_OUT",
          "inspectionStatus": "NONE"
        },
        {
          "bookingId": 2,
          "bookingCode": "BK-10111213",
          "roomNumber": 305,
          "roomKey": null,
          "checkInDate": "2026-02-10",
          "checkOutDate": "2026-02-12",
          "totalPrice": 2000,
          "bookingStatus": "APPROVED",
          "paymentStatus": "PAID",
          "checkInStatus": "NOT_CHECKED_IN",
          "checkOutStatus": "NOT_CHECKED_OUT",
          "inspectionStatus": "NONE"
        },
        {
          "bookingId": 3,
          "bookingCode": "BK-10111233",
          "roomNumber": 105,
          "roomKey": null,
          "checkInDate": "2026-02-23",
          "checkOutDate": "2026-02-25",
          "totalPrice": 1500,
          "bookingStatus": "APPROVED",
          "paymentStatus": "REFUNDED",
          "checkInStatus": "NOT_CHECKED_IN",
          "checkOutStatus": "NOT_CHECKED_OUT",
          "inspectionStatus": "NONE"
        }
      ]
    };
    try {
      final ResponseModel response = ResponseModel.fromJson(dataMock);

      if (response.statusCode == 200) {
        final listData = List<Map<String, dynamic>>.from(response.data);
        return listData;
      } else {
        throw Exception(response.message);
      }
    } on SocketException {
      throw Exception("ไม่มีการเขื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}
