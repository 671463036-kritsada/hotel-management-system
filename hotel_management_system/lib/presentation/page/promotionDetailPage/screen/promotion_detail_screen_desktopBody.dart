import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/core/constants.dart';
import '../provider/promotionDetail_provider.dart';

class PromotionDetailScreenDesktopbody extends StatefulWidget {
  final String promoId;

  const PromotionDetailScreenDesktopbody({super.key, required this.promoId});

  @override
  State<PromotionDetailScreenDesktopbody> createState() =>
      _PromotionDetailScreenDesktopbodyState();
}

class _PromotionDetailScreenDesktopbodyState
    extends State<PromotionDetailScreenDesktopbody> {
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

  @override
  Widget build(BuildContext context) {

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

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: (promo.imageUrl != null &&
                              promo.imageUrl!.isNotEmpty)
                          ? Image.network(promo.imageUrl!, fit: BoxFit.cover)
                          : Container(color: Colors.grey[200]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Constants.padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "รายละเอียดโปรโมชั่น",
                            style: TextStyle(
                              fontSize: Constants.fontSizeHeader,
                              fontWeight: Constants.fontWeightBold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            promo.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "รหัสโปรโมชั่น: ${promo.code}",
                            style:
                                const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            promo.description ?? '',
                            style:
                                const TextStyle(fontSize: 16, height: 1.6),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            promo.discountType == 'percentage'
                                ? "ส่วนลด ${promo.discountValue.toStringAsFixed(0)}%"
                                : "ส่วนลด ฿${promo.discountValue.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              );
            },
          ),
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Topnavbar(
                widthFactor: 0.2,
              )),
          const Positioned(
              bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
        ]),
      ),
    );
  }
}