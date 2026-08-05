import 'dart:io';
import 'package:hotel_management_system/data/model/furniture_model.dart';

abstract class furnitureRemoteDataSource {
  Future<List<Map<String, dynamic>>> getFurnitureData(String roomID);
  Future<bool> userFurnitureReport(List<FurnitureModel> reportData);
}

class furnitureRemoteDataSourceImpl implements furnitureRemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> getFurnitureData(String roomID) async {
    final furnitureMockData = {
      "message": "error something",
      "statusCode": 200,
      "data": [
        {
          "id": 1,
          "roomId": 205,
          "title": "เตียงนอน",
          "image": "assets/images/furnitures/bed.jpg",
          "inspections": [
            {
              "inspectorId": 5,
              "inspectorName": "แม่บ้าน สมหญิง",
              "inspectorRole": "housekeeper",
              "status": "ปกติ",
              "note": null,
              "damageImage": null,
              "inspectedAt": "2026-02-14T09:00:00Z"
            }
          ]
        },
        {
          "id": 2,
          "roomId": 205,
          "title": "เครื่องปรับอากาศ",
          "image": "assets/images/furnitures/airconditioner.jpg",
          "inspections": [
            {
              "inspectorId": 5,
              "inspectorName": "แม่บ้าน สมหญิง",
              "inspectorRole": "housekeeper",
              "status": "ปกติ",
              "note": null,
              "damageImage": null,
              "inspectedAt": "2026-02-14T09:02:00Z"
            }
          ]
        },
        {
          "id": 3,
          "roomId": 205,
          "title": "ตู้เย็น / มินิบาร์",
          "image": "assets/images/furnitures/fridge.jpg",
          "inspections": [
            {
              "inspectorId": 5,
              "inspectorName": "แม่บ้าน สมหญิง",
              "inspectorRole": "housekeeper",
              "status": "ปกติ",
              "note": null,
              "damageImage": null,
              "inspectedAt": "2026-02-14T09:03:00Z"
            }
          ]
        },
        {
          "id": 4,
          "roomId": 205,
          "title": "ทีวี และ รีโมท",
          "image": "assets/images/furnitures/TV.jpg",
          "inspections": [
            {
              "inspectorId": 5,
              "inspectorName": "แม่บ้าน สมหญิง",
              "inspectorRole": "housekeeper",
              "status": "ปกติ",
              "note": null,
              "damageImage": null,
              "inspectedAt": "2026-02-14T09:04:00Z"
            }
          ]
        }
      ]
    };

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      if (furnitureMockData["statusCode"] == 200) {
        return furnitureMockData["data"] as List<Map<String, dynamic>>;
      } else {
        throw Exception("Failed to load furniture");
      }
    } catch (e) {
      throw Exception("Failed to fetch funiture: $e");
    }
  }

  @override
  Future<bool> userFurnitureReport(List<FurnitureModel> reportData) async {
    try {
      reportData.forEach((item) {
        print(item.title);

        for (final inspection in item.inspections ?? []) {
          print(inspection.status);
          print(inspection.note);
          print(inspection.inspectorName);
          print(inspection.damageImage);
        }
      });

      await Future.delayed(const Duration(seconds: 2));
      if (reportData.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}
