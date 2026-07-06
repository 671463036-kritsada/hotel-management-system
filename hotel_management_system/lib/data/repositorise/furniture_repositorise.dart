import 'dart:io';

import 'package:hotel_management_system/data/data_source/remote_data_source/furniture_remote.dart';
import 'package:hotel_management_system/data/model/furniture_model.dart';

abstract class FurnitureRepositorise {
  Future<List<FurnitureModel>> getFurnitureData();
}

class FurnitureRepositoriseImpl implements FurnitureRepositorise {
  final furnitureRemoteDataSource remoteDataSource;
  FurnitureRepositoriseImpl(this.remoteDataSource);

  @override
  Future<List<FurnitureModel>> getFurnitureData() async {
    try {
       final furnitureData = await remoteDataSource.getFurnitureData();
      return List<FurnitureModel>.from(furnitureData);
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
