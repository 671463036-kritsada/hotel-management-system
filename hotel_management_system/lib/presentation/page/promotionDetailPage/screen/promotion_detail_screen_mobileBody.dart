import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/promotion_entitise.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:hotel_management_system/util/widget/components/bavbar/bottomNavbar.dart';
import 'package:hotel_management_system/util/widget/components/bavbar/topNavbar.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/core/constants.dart';
import '../provider/promotionDetail_provider.dart';

class PromotionDetailScreenMobilebody extends StatefulWidget {
  final String promoId;

  const PromotionDetailScreenMobilebody({super.key, required this.promoId});

  @override
  State<PromotionDetailScreenMobilebody> createState() =>
      _PromotionDetailScreenMobilebodyState();
}

class _PromotionDetailScreenMobilebodyState
    extends State<PromotionDetailScreenMobilebody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context
          .read<PromotiondetailProvide>()
          .fetchPromotionDetail(widget.promoId);
    });
  }

  String _formatDate(DateTime date) {
    const months = [
      'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year + 543}";
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          Consumer<PromotiondetailProvide>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.errorMessage.isNotEmpty) {
                return Center(child: Text(provider.errorMessage));
              }

              final promo = provider.promotion;
              if (promo == null) {
                return const Center(child: Text('ไม่พบข้อมูลโปรโมชั่น'));
              }

              return _buildContent(promo);
            },
          ),
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Topnavbar(
                widthFactor: 0.2,
                username: user?.name,
              )),
          Positioned(bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
        ]),
      ),
    );
  }

  Widget _buildContent(PromotionEntitise promo) {
    final remainingUses = promo.usageLimit != null
        ? (promo.usageLimit! - promo.usedCount).clamp(0, promo.usageLimit!)
        : null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),

          // รูปโปรโมชั่น
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 300,
                child: (promo.imageUrl != null && promo.imageUrl!.isNotEmpty)
                    ? Image.network(promo.imageUrl!, fit: BoxFit.cover)
                    : Container(color: Colors.grey[200]),
              ),
              if (!promo.isActive)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "ปิดใช้งานแล้ว",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(Constants.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promo.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // รหัสโปรโมชั่น
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Constants.primaryColor),
                  ),
                  child: Text(
                    "รหัส: ${promo.code}",
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                if (promo.description != null &&
                    promo.description!.isNotEmpty) ...[
                  Text(
                    promo.description!,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 20),
                ],

                Text(
                  "สิทธิพิเศษ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: Constants.fontWeightBold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  promo.discountType == 'percentage'
                      ? "ลด ${promo.discountValue.toStringAsFixed(0)}%"
                          "${promo.maxDiscountAmount != null ? " (สูงสุด ฿${promo.maxDiscountAmount!.toStringAsFixed(0)})" : ""}"
                      : "ลด ฿${promo.discountValue.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "เงื่อนไขการใช้บริการ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: Constants.fontWeightBold,
                  ),
                ),
                const SizedBox(height: 10),

                if (promo.minBookingAmount > 0)
                  _buildConditionRow(
                    Icons.receipt_long,
                    "ยอดจองขั้นต่ำ ฿${promo.minBookingAmount.toStringAsFixed(0)}",
                  ),

                if (promo.startDate != null && promo.endDate != null)
                  _buildConditionRow(
                    Icons.date_range,
                    "ใช้ได้ตั้งแต่วันที่ ${_formatDate(promo.startDate!)} "
                    "ถึง ${_formatDate(promo.endDate!)}",
                  ),

                if (remainingUses != null)
                  _buildConditionRow(
                    Icons.confirmation_number,
                    remainingUses > 0
                        ? "เหลือสิทธิ์การใช้งานอีก $remainingUses ครั้ง"
                        : "สิทธิ์การใช้งานหมดแล้ว",
                  ),

                const SizedBox(height: 10),
                const Text(
                  "ไม่สามารถใช้ร่วมกับโปรโมชั่นอื่นได้",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildConditionRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Constants.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}