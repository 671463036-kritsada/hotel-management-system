import 'dart:io';
import 'package:hotel_management_system/data/data_source/remote_data_source/booking_form_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/home_remote.dart';
import 'package:hotel_management_system/data/model/booking_form_model.dart';
import '../../util/widget/core/constants.dart';

abstract class BookingFormRepositorise {
  Future<bool> bookingForm(BookingFormModel bookingData);
  Future<double> getRoomPricePerNight(String roomId); // เพิ่มใหม่: ใช้ดึงราคาไปแสดง preview ก่อนจอง
}

class BookingFormRepositoriseImpl implements BookingFormRepositorise {
  final BookingFormRemoteDataSourceImpl remoteDataSource;
  final HomeRemoteDataSource homeRemoteDataSource;

  BookingFormRepositoriseImpl(
    this.remoteDataSource,
    this.homeRemoteDataSource,
  );

  // เพิ่มใหม่: ดึงราคาต่อคืนจาก DB (แปลง String -> double ให้ตรงนี้ที่เดียว)
  // ใช้ทั้งตอนแสดง preview ในฟอร์ม และตอน insert จริงใน bookingForm()
  @override
  Future<double> getRoomPricePerNight(String roomId) async {
    try {
      final room = await homeRemoteDataSource.getRoomById(roomId);
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
      // 0. Validate ข้อมูลที่จำเป็นก่อนคำนวณ (เพราะทุก field เป็น nullable)
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

      // 1. ดึงราคาต่อคืนจริงจาก DB (ใช้ method เดียวกับที่ใช้แสดง preview)
      //    ไม่เชื่อ totalPrice ที่ client ส่งมาเลย
      final pricePerNight = await getRoomPricePerNight(roomId);

      // 2. คำนวณจำนวนคืนจากวันที่ และ validate ว่าถูกต้อง
      final nights = checkOut.difference(checkIn).inDays;
      if (nights <= 0) {
        throw Exception("วันที่เช็คอิน-เช็คเอาท์ไม่ถูกต้อง");
      }

      // 3. คำนวณราคาจริง
      final totalPrice = pricePerNight * nights * roomsCount;
      final depositAmount = totalPrice * Constants.depositPercent;
      final remainingAmount = totalPrice - depositAmount;

      // 4. เซ็ตค่าราคาที่คำนวณเองกลับเข้าไปใน model (ทับค่าเดิมที่ client ส่งมา)
      bookingData.totalPrice = totalPrice;
      bookingData.depositAmount = depositAmount;
      bookingData.remainingAmount = remainingAmount;

      // 5. ยิง insert booking ด้วยข้อมูลราคาที่ยืนยันแล้ว
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