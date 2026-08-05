import 'dart:io';

import 'package:hotel_management_system/data/repositorise/list_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/list_entitise.dart';

class ListUsecase {
  final ListRepositoriseImpl repository;
  ListUsecase(this.repository);

  Future<List<BookingListEntity>> getListData() async {
    try {
      final listDataModel = await repository.getListData();
      return listDataModel
          .map((item) => BookingListEntity(
              bookingId: item.bookingId ?? -1,
              bookingCode: item.bookingCode ?? "",
              roomNumber: item.roomNumber ?? 0,
              roomKey: item.roomKey ?? "",
              checkInDate: item.checkInDate,
              checkOutDate: item.checkOutDate,
              totalPrice: (item.totalPrice ?? 0).toDouble(),
              bookingStatus: item.bookingStatus ?? "",
              paymentStatus: item.paymentStatus ?? "",
              checkInStatus: item.checkInStatus ?? "",
              checkOutStatus: item.checkOutStatus ?? "",
              inspectionStatus: item.inspectionStatus ?? ""))
          .toList();
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}
