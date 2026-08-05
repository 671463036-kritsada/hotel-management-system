import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/responseModelRemote/response_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<Map<String, dynamic>>> getRooms();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  static const String _endpoint = 'rooms';

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Map<String, dynamic>>> getRooms() async {
    try {
      final response = await dio.get(_endpoint);
      final ResponseModel responseModel =
          ResponseModel.fromJson(response.data as Map<String, dynamic>);
      if (responseModel.statusCode == 200) {
        final data = responseModel.data;
        if (data is List) {
          return data
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        }
        throw Exception('Invalid room data format');
      } else {
        throw Exception(responseModel.message ?? 'Failed to load rooms');
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
        case DioExceptionType.connectionError:
          throw Exception(
              'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
        case DioExceptionType.badResponse:
          throw Exception(
              'เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${e.response?.statusCode}');
        default:
          throw Exception('เกิดข้อผิดพลาด: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch rooms: $e');
    }
  }
}
