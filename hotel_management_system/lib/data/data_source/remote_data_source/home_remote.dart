import 'package:hotel_management_system/data/model/responseModelRemote/response_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<Map<String, dynamic>>> getRooms();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> getRooms() async {
    final dataMock = {
      "message": "error something",
      "statusCode": 200,
      "data": [
        ...List.generate(
          10,
          (index) => {
            "roomId": index + 1,
            "roomType": "rooms",
            "imageUrls": [
              "assets/images/rooms/room${index + 1}.jpg",
              "assets/images/rooms/room${(index % 3) + 1}.jpg",
            ],
            "description":
                "สัมผัสประสบการณ์การพักผ่อนที่เหนือระดับ ด้วยห้องพักที่ตกแต่งอย่างทันสมัย พร้อมสิ่งอำนวยความสะดวกครบครัน",
            "pricePerNight": (index + 1) * 500.0,
            "status": "ว่าง",
          },
        ),
        ...List.generate(
          15,
          (index) => {
            "roomId": index + 1,
            "roomType": "house",
            "imageUrls": [
              "assets/images/houses/house${index + 1}.jpg",
              "assets/images/houses/house${(index % 3) + 1}.jpg",
            ],
            "description":
                "บ้านพักส่วนตัวพร้อมบรรยากาศที่อบอุ่น เหมาะสำหรับครอบครัวหรือกลุ่มเพื่อน",
            "pricePerNight": (index + 1) * 500.0,
            "status": "ว่าง",
          },
        ),
      ]
    };

    try {
      final ResponseModel response = ResponseModel.fromJson(dataMock);
      await Future.delayed(const Duration(milliseconds: 300));

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        }
        throw Exception('Invalid room data format');
      } else {
        throw Exception(response.message ?? 'Failed to load rooms');
      }
    } catch (e) {
      throw Exception('Failed to fetch rooms: $e');
    }
  }
}
