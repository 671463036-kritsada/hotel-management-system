import 'dart:io';

import 'package:hotel_management_system/data/data_source/remote_data_source/booking_form_remote.dart';
import 'package:hotel_management_system/data/model/booking_form_model.dart';

abstract class BookingFormRepositorise {
  Future<bool> bookingForm(BookingFormModel bookingData);
}

class BookingFormRepositoriseImpl implements BookingFormRepositorise {
  final BookingFormRemoteDataSourceImpl remoteDataSource;

  BookingFormRepositoriseImpl(this.remoteDataSource);
  @override
  Future<bool> bookingForm(BookingFormModel bookingData) async {
    try {
      return await remoteDataSource.bookingForm(bookingData) ;
    } on SocketException {
      // error เฉพาะ เช่น ไม่มีอินเตอร์เน็ต
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } on HttpException {
      // error จาก HTTP
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      // error ทั่วไปที่ไม่รู้ประเภท
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }
}
