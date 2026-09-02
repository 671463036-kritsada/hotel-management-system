import 'dart:io';
import 'package:hotel_management_system/data/data_source/remote_data_source/booking_form_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/home_remote.dart';
import 'package:hotel_management_system/data/model/booking_form_model.dart';
import 'package:hotel_management_system/data/model/home_model.dart'; // เพิ่ม
import '../../util/widget/core/constants.dart';

abstract class BookingFormRepositorise {
  Future<bool> bookingForm(BookingFormModel bookingData);
  Future<double> getRoomPricePerNight(String roomId);
}

class BookingFormRepositoriseImpl implements BookingFormRepositorise {
  final BookingFormRemoteDataSourceImpl remoteDataSource;
  final HomeRemoteDataSource homeRemoteDataSource;

  BookingFormRepositoriseImpl(
    this.remoteDataSource,
    this.homeRemoteDataSource,
  );

  @override
  Future<double> getRoomPricePerNight(String roomId) async {
    try {
      final rawRoom = await homeRemoteDataSource.getRoomById(roomId); // ได้ raw Map แล้ว
      final room = HomeModel.fromJson(rawRoom); // เพิ่ม: แปลงเป็น Model เองตรงนี้
      final price = double.tryParse(room.pricePerNight ?? '') ?? 0;
      if (price <= 0) {
        throw Exception("ราคาห้องพักไม่ถูกต้อง");
      }
      return price;
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Future<bool> bookingForm(BookingFormModel bookingData) async {
    try {
      final roomId = bookingData.roomId;
      final checkIn = bookingData.checkInDate;
      final checkOut = bookingData.checkOutDate;
      final roomsCount = bookingData.roomsCount ?? 1;

      if (roomId == null || roomId.isEmpty) {
        throw Exception("ไม่พบรหัสห้องพัก");
      }
      if (checkIn == null || checkOut == null) {
        throw Exception("กรุณาเลือกวันที่เช็คอิน-เช็คเอาท์");
      }

      final pricePerNight = await getRoomPricePerNight(roomId);

      final nights = checkOut.difference(checkIn).inDays;
      if (nights <= 0) {
        throw Exception("วันที่เช็คอิน-เช็คเอาท์ไม่ถูกต้อง");
      }

      final totalPrice = pricePerNight * nights * roomsCount;
      final depositAmount = totalPrice * Constants.depositPercent;
      final remainingAmount = totalPrice - depositAmount;

      bookingData.totalPrice = totalPrice;
      bookingData.depositAmount = depositAmount;
      bookingData.remainingAmount = remainingAmount;

      return await remoteDataSource.bookingForm(bookingData);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }
}