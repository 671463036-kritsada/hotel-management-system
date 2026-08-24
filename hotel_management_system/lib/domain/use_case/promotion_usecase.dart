import 'package:hotel_management_system/data/repositorise/promotion_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/promotion_entitise.dart';

class PromotionUsecase {
  final PromotionRepositoriseImpl repository;
  PromotionUsecase(this.repository);

  Future<List<PromotionEntitise>> getActivePromotions() async {
    try {
      return await repository.getActivePromotions();
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }

  Future<PromotionEntitise> getPromotionById(String id) async {
    try {
      return await repository.getPromotionById(id);
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }

  /// คืน userPromotionId ที่เพิ่งได้รับ ใช้ตอนจะ refresh หน้า coupon list ต่อ
  Future<int> claimPromotion(String promotionId) async {
    try {
      return await repository.claimPromotion(promotionId);
    } catch (e) {
      rethrow; // ให้ provider จับ message จริงไปแสดงเป็น snackbar
    }
  }

  Future<List<UserCouponEntitise>> getMyCoupons({String status = "available"}) async {
    try {
      return await repository.getMyCoupons(status: status);
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }
}