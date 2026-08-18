import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/promotionDetailPage/screen/promotion_detail_screen_desktopBody.dart';
import 'package:hotel_management_system/presentation/page/promotionDetailPage/screen/promotion_detail_screen_mobileBody.dart';
import 'package:hotel_management_system/presentation/responsiveLayout/responsive_layout.dart';

class PromotionDetailScreen extends StatelessWidget {
  const PromotionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: PromotionDetailScreenMobilebody(),
        desktopBody: PromotionDetailScreenDesktopbody());
  }
}
