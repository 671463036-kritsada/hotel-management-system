import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/responseModelRemote/response_model.dart';

abstract class ListRemoteDatasource {
  Future<List<Map<String, dynamic>>> getListData();
}

class ListRemoteDatasourceImpl implements ListRemoteDatasource {
  final Dio dio;

  // TODO: hardcode ไว้ทดสอบก่อน ระยะยาวควรดึงจาก login/secure storage แทน
  static const String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IlUwMDQiLCJuYW1lIjoi4LiX4LiU4Liq4Lit4LiaIOC4o-C4sOC4muC4miIsInJvbGUiOiJVc2VyIiwiaWF0IjoxNzg1OTE5NzgyLCJleHAiOjE3ODYwMDYxODJ9.hue_BKlGjzwLe2mNDilW_ihGG1n1l8tZIhzIYAet5Lg';

  static const String _endpoint = 'bookings/my-bookings';

  ListRemoteDatasourceImpl(this.dio);

  @override
  Future<List<Map<String, dynamic>>> getListData() async {
    try {
      final response = await dio.get(
        _endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      final ResponseModel responseModel =
          ResponseModel.fromJson(response.data as Map<String, dynamic>);

      if (responseModel.isSuccess) {
        final data = responseModel.data;
        if (data is List) {
          return data
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        }
        throw Exception('Invalid booking data format');
      } else {
        throw Exception(responseModel.message ?? 'Failed to load bookings');
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
          if (e.response?.statusCode == 401) {
            throw Exception('Token หมดอายุหรือไม่ถูกต้อง กรุณาเข้าสู่ระบบใหม่');
          }
          throw Exception(
              'เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${e.response?.statusCode}');
        default:
          throw Exception('เกิดข้อผิดพลาด: ${e.message}');
      }
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาด: $e');
    }
  }
}
