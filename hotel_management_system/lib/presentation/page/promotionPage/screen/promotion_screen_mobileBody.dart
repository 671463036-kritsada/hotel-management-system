import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/promotion_entitise.dart';
import 'package:hotel_management_system/presentation/page/promotionPage/components/boxShow_new.dart';
import 'package:hotel_management_system/util/widget/components/bavbar/bottomNavbar.dart';
import 'package:hotel_management_system/util/widget/components/bavbar/topNavbar.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';
import 'package:provider/provider.dart';

import '../../../../util/model/model.dart';
import '../../../../util/widget/components/button/button.dart';
import '../components/boxShow_promotion_card.dart';
import '../provider/promotion_provider.dart';

class PromotionScreenMobilebody extends StatefulWidget {
  const PromotionScreenMobilebody({super.key});

  @override
  State<PromotionScreenMobilebody> createState() =>
      _PromotionScreenMobilebodyState();
}

class _PromotionScreenMobilebodyState
    extends State<PromotionScreenMobilebody> {
  static const String _fallbackImageUrl =
      "https://images.unsplash.com/photo-1600585154340-be6161a56a0c";

  // --- เก็บวันที่ที่ผู้ใช้เลือกไว้เอง ไม่ต้องพึ่ง HomeScreenProvider ---
  // เพราะ route "/promotion_page" ไม่มี HomeScreenProvider ครอบอยู่
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromotionProvider>().fetchActivePromotions();
    });
  }

  Future<void> _pickDateRange(
    BuildContext context,
    StateSetter setSheetState,
  ) async {
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _checkInDate != null && _checkOutDate != null
          ? DateTimeRange(start: _checkInDate!, end: _checkOutDate!)
          : null,
    );

    if (picked != null) {
      setSheetState(() {
        _checkInDate = picked.start;
        _checkOutDate = picked.end;
      });
    }
  }

  Widget _buildDateFilterChip(
    BuildContext context,
    StateSetter setSheetState,
  ) {
    final hasDateFilter = _checkInDate != null && _checkOutDate != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () => _pickDateRange(context, setSheetState),
          icon: const Icon(Icons.calendar_today, size: 16),
          label: Text(
            hasDateFilter
                ? "${_checkInDate!.day}/${_checkInDate!.month} - ${_checkOutDate!.day}/${_checkOutDate!.month}"
                : "เลือกวันที่เข้าพัก",
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Constants.primaryColor,
            side: BorderSide(color: Constants.primaryColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
          ),
        ),
        if (hasDateFilter) ...[
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              setSheetState(() {
                _checkInDate = null;
                _checkOutDate = null;
              });
            },
            tooltip: "ล้างตัวกรองวันที่",
          ),
        ],
      ],
    );
  }

  void _openDateFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SizedBox(
              height: 220,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildDateFilterChip(context, setSheetState),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      child: const Text('ยืนยันและค้นหาห้อง'),
                      onPressed: () {
                        if (_checkInDate == null || _checkOutDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('กรุณาเลือกวันที่เข้าพักก่อน'),
                            ),
                          );
                          return;
                        }

                        Navigator.pop(bottomSheetContext); // ปิด BottomSheet

                        // ใช้ context หลักของหน้า Promotion (this.context)
                        // ไม่ใช่ bottomSheetContext ที่กำลังจะถูก dispose
                        Navigator.pushNamed(
                          this.context,
                          "/home",
                          arguments: HomeFilterArgs(
                            checkIn: _checkInDate!,
                            checkOut: _checkOutDate!,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(fit: StackFit.expand, children: [
        Padding(
          padding: const EdgeInsets.all(Constants.padding),
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "ข่าวสารและประชาสัมพันธ์",
                          style: TextStyle(
                              fontSize: Constants.fontSizeHeader,
                              fontWeight: Constants.fontWeightBold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    _buildBanner(),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Button(
                          text: "จองเลย ตอนนี้",
                          onTap: () => _openDateFilterSheet(context),
                          btnSize: 250,
                          color: Constants.primaryColor),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Text(
                            "โปรโมชั่นพิเศษ",
                            style: TextStyle(
                                fontSize: Constants.fontSizeHeader,
                                fontWeight: Constants.fontWeightBold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      _buildPromotionList(),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Topnavbar(
              widthFactor: 0.2,
            )),
        Positioned(bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
      ])),
    );
  }

  /// Banner บนสุด: ใช้รูปจากโปรโมชั่นจริงที่มี imageUrl (ถ้ายังโหลดไม่เสร็จ/ไม่มี ให้ซ่อนไปเลย)
  Widget _buildBanner() {
    return Consumer<PromotionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingPromotions) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final bannerImages = provider.promotions
            .where((p) => p.imageUrl != null && p.imageUrl!.isNotEmpty)
            .map((p) => PromotionImage(id: p.id, imageUrl: p.imageUrl!))
            .toList();

        if (bannerImages.isEmpty) {
          return const SizedBox.shrink();
        }

        return BoxshowNew(
          images: bannerImages,
          onTap: (id) {
            Navigator.pushNamed(
              context,
              "/promotion_detail_page",
              arguments: id.toString(),
            );
          },
        );
      },
    );
  }

  Widget _buildPromotionList() {
    return Consumer<PromotionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingPromotions) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.promotionsError != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Text(
                  provider.promotionsError!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () => provider.fetchActivePromotions(),
                  child: Text("ลองใหม่อีกครั้ง"),
                ),
              ],
            ),
          );
        }

        if (provider.promotions.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: Text("ยังไม่มีโปรโมชั่นในขณะนี้")),
          );
        }

        return Column(
          children: provider.promotions
              .map((promo) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildPromotionCard(promo),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildPromotionCard(PromotionEntitise promo) {
    final priceLabel = promo.discountType == 'percentage'
        ? "-${promo.discountValue.toStringAsFixed(0)}%"
        : "-฿${promo.discountValue.toStringAsFixed(0)}";

    return BoxshowPromotionCard(
      title: promo.title,
      description: promo.description ?? '',
      bedsInfo: "รหัส: ${promo.code}",
      price: priceLabel,
      textColor: Colors.black,
      rating: 0,
      reviewCount: 0,
      imageUrl: (promo.imageUrl != null && promo.imageUrl!.isNotEmpty)
          ? promo.imageUrl!
          : _fallbackImageUrl,
      onTap: () {
        Navigator.pushNamed(
          context,
          "/promotion_detail_page",
          arguments: promo.id.toString(),
        );
      },
      onFavoriteChanged: (value) {},
    );
  }
}