import 'dart:io';

abstract class HousekeeperRoomRemoteDataSource {
  Future<List<Map<String, dynamic>>> getRooms();
  Future<bool> saveRoomDetail({
    required String roomNo,
    required String cleaningStatus,
  });
}

class HousekeeperRoomRemoteDataSourceImpl
    implements HousekeeperRoomRemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> getRooms() async {
    final mockData = {
      "message": "success",
      "statusCode": 200,
      "data": [
        ...List.generate(50, (index) {
          int floor = (index ~/ 10) + 1;
          int roomNum = (index % 10) + 1;
          String roomNo = "$floor${roomNum.toString().padLeft(2, '0')}";
          List<String> statuses = [
            "มีลูกค้าพักอยู่",
            "รอทำความสะอาด",
            "เสร็จสิ้น",
            "ปิดปรับปรุง",
          ];
          return {
            "roomNo": roomNo,
            "status": statuses[index % 4],
          };
        }),
      ],
    };

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mockData["statusCode"] == 200) {
        final List<Map<String, dynamic>> result =
            List<Map<String, dynamic>>.from(mockData["data"] as List);

        // Log แสดงข้อมูล
        print("=== getRooms success ===");
        print("statusCode: ${mockData["statusCode"]}");
        print("message: ${mockData["message"]}");
        print("total rooms: ${result.length}");
        for (var room in result) {
          print("roomNo: ${room["roomNo"]} | status: ${room["status"]}");
        }
        print("========================");

        return result;
      } else {
        throw Exception("Failed to load rooms");
      }
    } on SocketException {
      print("SocketException: ไม่มีการเชื่อมต่อ internet");
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } catch (e) {
      print("Error: $e");
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }

@override
Future<bool> saveRoomDetail({
  required String roomNo,
  required String cleaningStatus,
}) async {
  try {
    print("=== saveRoomDetail ===");
    print("roomNo: $roomNo");
    print("cleaningStatus: $cleaningStatus");

    await Future.delayed(const Duration(milliseconds: 500));

    print("saveRoomDetail success");
    print("=====================");
    return true;
  } on SocketException {
    print("SocketException: ไม่มีการเชื่อมต่อ internet");
    throw Exception("ไม่มีการเชื่อมต่อ internet");
  } catch (e) {
    print("Error: $e");
    throw Exception("เกิดข้อผิดพลาด $e");
  }
}
}
