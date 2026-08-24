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

  double calculateDiscount(double baseAmount) {
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