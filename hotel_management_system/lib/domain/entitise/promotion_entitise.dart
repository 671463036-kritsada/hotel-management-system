class PromotionEntitise {
  final int id;
  final String code;
  final String title;
  final String? description;
  final String? imageUrl;
  final String discountType;
  final double discountValue;
  final double minBookingAmount;
  final double? maxDiscountAmount;
  final int? usageLimit;
  final int usedCount;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;

  PromotionEntitise({
    required this.id,
    required this.code,
    required this.title,
    this.description,
    this.imageUrl,
    required this.discountType,
    required this.discountValue,
    required this.minBookingAmount,
    this.maxDiscountAmount,
    this.usageLimit,
    required this.usedCount,
    this.startDate,
    this.endDate,
    required this.isActive,
  });
}

class UserCouponEntitise {
  final int userPromotionId;
  final String status; // 'available' | 'used' | 'expired'
  final DateTime? receivedAt;
  final DateTime? usedAt;
  final String? bookingId;
  final int promotionId;
  final String code;
  final String title;
  final String? description;
  final String discountType;
  final double discountValue;
  final double minBookingAmount;
  final double? maxDiscountAmount;
  final DateTime? endDate;

  UserCouponEntitise({
    required this.userPromotionId,
    required this.status,
    this.receivedAt,
    this.usedAt,
    this.bookingId,
    required this.promotionId,
    required this.code,
    required this.title,
    this.description,
    required this.discountType,
    required this.discountValue,
    required this.minBookingAmount,
    this.maxDiscountAmount,
    this.endDate,
  });

  // เช็คหมดอายุจาก endDate ตรงๆ แยกจาก status
  // เผื่อกรณี status ที่โหลดมาตอนเปิดหน้ายังไม่ถูกอัปเดต (เช่น cache ค้าง)
  // แต่ endDate ผ่านไปแล้วจริงๆ ณ ตอนที่ user กำลังจะกดใช้
  bool get isExpiredByDate {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  // รวมทุกเงื่อนไขไว้จุดเดียว คืน null = ใช้ได้,
  // ไม่ null = เหตุผลที่ใช้ไม่ได้ (เอาไปโชว์เป็น subtitle สีเทาได้เลย)
  String? unavailableReason(double baseAmount) {
    if (status == 'used') return 'ใช้ไปแล้ว';
    if (status == 'expired' || isExpiredByDate) return 'หมดอายุแล้ว';
    if (baseAmount < minBookingAmount) {
      return 'ยอดจองขั้นต่ำ ${minBookingAmount.toStringAsFixed(0)} บาท';
    }
    return null;
  }

  bool isUsable(double baseAmount) => unavailableReason(baseAmount) == null;

  double calculateDiscount(double baseAmount) {
    // เคารพยอดขั้นต่ำ ถ้ายอดไม่ถึง ไม่คำนวณส่วนลดให้เลย
    // (บั๊กเดิม ไม่เช็คตรงนี้มาก่อน ทำให้ได้ส่วนลดทั้งที่ไม่ควรได้)
    if (baseAmount < minBookingAmount) return 0;

    double discount;
    if (discountType == 'percentage') {
      discount = baseAmount * (discountValue / 100);
      if (maxDiscountAmount != null && discount > maxDiscountAmount!) {
        discount = maxDiscountAmount!;
      }
    } else {
      discount = discountValue;
    }
    if (discount > baseAmount) discount = baseAmount;
    return discount < 0 ? 0 : discount;
  }
}
