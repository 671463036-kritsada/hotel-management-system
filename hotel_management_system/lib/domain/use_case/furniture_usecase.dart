import 'dart:io';
import 'package:hotel_management_system/data/repositorise/furniture_repositorise.dart';
import 'package:hotel_management_system/data/model/furniture_model.dart';
import 'package:hotel_management_system/domain/entitise/furniture_entitise.dart';

class FurnitureUsecase {
  final FurnitureRepositoriseImpl repository;
  FurnitureUsecase(this.repository);

  Future<List<FurnitureEntitise>> getFurnitureData(int roomID) async {
    try {
      final modelData = await repository.getFurnitureData(roomID);
      return modelData.map((item) {
        final housekeeperInspection = item.inspections
            ?.where((i) => i.inspectorRole == 'housekeeper')
            .lastOrNull;
        return FurnitureEntitise(
          roomID: roomID,
          title: item.title,
          image: item.image,
          isCustom: item.isCustom ?? false,
          status: housekeeperInspection?.status ?? "ยังไม่ได้ตรวจสอบ",
        );
      }).toList();
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }

  Future<bool> submitReport(List<FurnitureEntitise> reportData) async {
    try {
      final reportModels = reportData.map((e) {
        return FurnitureModel(
          roomId: e.roomID,
          title: e.title,
          image: e.image,
          isCustom: e.isCustom,
          inspections: [
            Inspection(
              status: e.status,
              note: e.note,
              damageImage: e.damageImage,
              inspectedAt: DateTime.now(),
            )
          ],
        );
      }).toList();
      return await repository.submitReport(reportModels);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}