import 'dart:io';
import 'package:hotel_management_system/data/data_source/remote_data_source/promotion_remote.dart';
import 'package:hotel_management_system/domain/entitise/promotion_entitise.dart';

abstract class PromotionRepositorise {
  Future<List<PromotionEntitise>> getActivePromotions();
  Future<PromotionEntitise> getPromotionById(String id);
  Future<int> claimPromotion(String promotionId);
  Future<List<UserCouponEntitise>> getMyCoupons({String status});
}

class PromotionRepositoriseImpl implements PromotionRepositorise {
  final PromotionRemoteDataSource remoteDataSource;
  PromotionRepositoriseImpl(this.remoteDataSource);

  @override
  Future<List<PromotionEntitise>> getActivePromotions() async {
    try {
      final models = await remoteDataSource.getActivePromotions();
      return models.map((m) => m.toEntity()).toList();
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Future<PromotionEntitise> getPromotionById(String id) async {
    try {
      final model = await remoteDataSource.getPromotionById(id);
      return model.toEntity();
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Future<int> claimPromotion(String promotionId) async {
    try {
      return await remoteDataSource.claimPromotion(promotionId);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } catch (e) {
      rethrow; // ส่ง message จริงจาก backend (เช่น "คุณได้รับคูปองนี้ไปแล้ว") ต่อไปตรงๆ
    }
  }

  @override
  Future<List<UserCouponEntitise>> getMyCoupons({String status = "available"}) async {
    try {
      final models = await remoteDataSource.getMyCoupons(status: status);
      return models.map((m) => m.toEntity()).toList();
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }
}