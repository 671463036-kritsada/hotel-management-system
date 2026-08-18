import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/furniture_model.dart';

import '../../../util/widget/core/network/dio_client.dart';

abstract class furnitureRemoteDataSource {
  Future<List<Map<String, dynamic>>> getFurnitureData(
      String roomID, String bookingId);
  Future<bool> userFurnitureReport(List<FurnitureModel> reportData);
}

class furnitureRemoteDataSourceImpl implements furnitureRemoteDataSource {
  final Dio _dio = DioClient.dio;

  @override
  Future<List<Map<String, dynamic>>> getFurnitureData(
      String roomID, String bookingId) async {
    try {
      final response = await _dio.get(
        "furniture", // baseUrl ลงท้าย /api/ อยู่แล้ว → path นี้จะกลายเป็น /api/furniture
        queryParameters: {
          "roomId": roomID,
          "bookingId": bookingId,
        },
      );

      final List<dynamic> data = response.data["data"] ?? [];
      return data.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw Exception(
          e.response?.data?["message"] ?? "ไม่สามารถโหลดข้อมูลเฟอร์นิเจอร์ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Future<bool> userFurnitureReport(List<FurnitureModel> reportData) async {
    try {
      final body = reportData.map((e) => e.toJson()).toList();

      final response = await _dio.post(
        "furniture/report",
        data: body,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(e.response?.data?["message"] ?? "ส่งรายงานไม่สำเร็จ");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }
}