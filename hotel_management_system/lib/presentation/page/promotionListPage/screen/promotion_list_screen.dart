import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/promotionDetailPage/screen/promotion_detail_screen_mobileBody.dart';
import 'package:hotel_management_system/presentation/page/promotionListPage/screen/promotion_list_desktopBody.dart';
import 'package:hotel_management_system/presentation/responsiveLayout/responsive_layout.dart';

class PromotionListScreen extends StatelessWidget {
  const PromotionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: PromotionDetailScreenMobilebody(),
        desktopBody: PromotionListDesktopbody());
  }
}
