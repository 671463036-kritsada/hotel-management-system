import 'dart:io';
import 'package:hotel_management_system/data/data_source/remote_data_source/furniture_remote.dart';
import 'package:hotel_management_system/data/model/furniture_model.dart';

abstract class FurnitureRepositorise {
  Future<List<FurnitureModel>> getFurnitureData(String roomID);
  Future<bool> submitReport(List<FurnitureModel> submitData);
}

class FurnitureRepositoriseImpl implements FurnitureRepositorise {
  final furnitureRemoteDataSource remoteDataSource;
  FurnitureRepositoriseImpl(this.remoteDataSource);

  @override
  Future<List<FurnitureModel>> getFurnitureData(String roomID) async {
    try {
      final furnitureData = await remoteDataSource.getFurnitureData(roomID);
      return furnitureData
          .map((json) => FurnitureModel.fromJson(json))
          .toList();
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Future<bool> submitReport(List<FurnitureModel> submitData) async {
    try {
      return await remoteDataSource.userFurnitureReport(submitData);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}
