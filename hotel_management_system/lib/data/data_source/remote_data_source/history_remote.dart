import 'dart:io';

abstract class BookingHistoryRemoteDataSource {
  Future<List<Map<String, dynamic>>> getBookingHistory();
  Future<bool> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  });
}

class BookingHistoryRemoteDataSourceImpl
    implements BookingHistoryRemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> getBookingHistory() async {
    final mockData = {
      "message": "success",
      "statusCode": 200,
      "data": [
        {
          "bookingId": "BK-10111223",
          "roomNumber": "205",
          "checkInDate": "2026-02-15",
          "checkOutDate": "2026-02-17",
          "totalAmount": 1000,
          "review": null,
        },
        {
          "bookingId": "BK-10111213",
          "roomNumber": "305",
          "checkInDate": "2026-02-10",
          "checkOutDate": "2026-02-12",
          "totalAmount": 2000,
          "review": null,
        },
        {
          "bookingId": "BK-10111233",
          "roomNumber": "105",
          "checkInDate": "2026-02-23",
          "checkOutDate": "2026-02-25",
          "totalAmount": 1500,
          "review": null,
        },
        {
          "bookingId": "BK-10111199",
          "roomNumber": "402",
          "checkInDate": "2026-01-05",
          "checkOutDate": "2026-01-07",
          "totalAmount": 1800,
          "review": {
            "rating": 4,
            "comment": "ห้องสะอาด พนักงานบริการดี",
            "reviewedAt": "2026-01-08T10:30:00Z",
          },
        },
      ]
    };

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mockData["statusCode"] == 200) {
        return List<Map<String, dynamic>>.from(mockData["data"] as List);
      } else {
        throw Exception("Failed to load booking history");
      }
    } catch (e) {
      throw Exception("Failed to fetch booking history: $e");
    }
  }

  @override
  Future<bool> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    try {
      print("Submit review -> bookingId: $bookingId, rating: $rating, comment: $comment");
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}