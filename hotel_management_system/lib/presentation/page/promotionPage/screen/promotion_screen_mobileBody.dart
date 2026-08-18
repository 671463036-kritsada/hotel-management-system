import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/promotionPage/components/boxShow_new.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:hotel_management_system/util/widget/components/bavbar/bottomNavbar.dart';
import 'package:hotel_management_system/util/widget/components/bavbar/topNavbar.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/components/button/button.dart';
import '../components/boxShow_promotion_card.dart';

class PromotionScreenMobilebody extends StatefulWidget {
  const PromotionScreenMobilebody({super.key});

  @override
  State<PromotionScreenMobilebody> createState() =>
      _PromotionScreenMobilebodyState();
}

class _PromotionScreenMobilebodyState extends State<PromotionScreenMobilebody> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

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
                    BoxshowNew(
                      images: [
                        PromotionImage(
                          id: 1,
                          imageUrl:
                              "https://www.amarinsamuiresort.com/images/promotion/banner-promotion-amarin-1.jpg",
                        ),
                        PromotionImage(
                          id: 2,
                          imageUrl:
                              "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/hotel-promotion-flyer-template-design-570b9352e1e630985d11a6338fd5255c_screen.jpg?ts=1732552875",
                        ),
                        PromotionImage(
                          id: 3,
                          imageUrl:
                              "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/hotel-promotion-discount-instagram-design-template-c9bd0ab0cd00aa7f8943317278b0f893_screen.jpg?ts=1616492668",
                        ),
                        PromotionImage(
                          id: 4,
                          imageUrl:
                              "https://img.magnific.com/premium-psd/hotel-promo-unlock-luxury-with-up-30-off-social-media-post-design-psd_664694-284.jpg?semt=ais_test_b&w=740&q=80",
                        ),
                        PromotionImage(
                          id: 5,
                          imageUrl:
                              "https://cdn.studios.skies.asia/www.mandarin-bkk.com/large/6ppZ4NruZP_1653466244.png",
                        ),
                      ],
                      onTap: (id) {
                        print("กด Promotion ID: $id");

                        Navigator.pushNamed(
                          context,
                          "/promotion_detail_page",
                          arguments: id,
                        );
                      },
                    ),
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
                        onTap: () {
                          Navigator.pushNamed(context, "/home");
                        },
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
                    BoxshowPromotionCard(
                      title: "พักผ่อนเหนือระดับที่เชียงราย",
                      description: "บ้านพักส่วนตัวพร้อมวิวภูเขา",
                      bedsInfo: "เตียงคู่ • 1 ห้องน้ำ",
                      price: "฿2,500",
                      textColor: Colors.black,
                      rating: 4.97,
                      reviewCount: 156,
                      imageUrl:
                          "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                      onTap: () {},
                      onFavoriteChanged: (value) {},
                    ),
                    BoxshowPromotionCard(
                      title: "พักผ่อนเหนือระดับที่เชียงราย",
                      description: "บ้านพักส่วนตัวพร้อมวิวภูเขา",
                      bedsInfo: "เตียงคู่ • 1 ห้องน้ำ",
                      price: "฿2,500",
                      textColor: Colors.black,
                      rating: 4.97,
                      reviewCount: 156,
                      imageUrl:
                          "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                      onTap: () {},
                      onFavoriteChanged: (value) {},
                    ),
                    BoxshowPromotionCard(
                      title: "พักผ่อนเหนือระดับที่เชียงราย",
                      description: "บ้านพักส่วนตัวพร้อมวิวภูเขา",
                      bedsInfo: "เตียงคู่ • 1 ห้องน้ำ",
                      price: "฿2,500",
                      textColor: Colors.black,
                      rating: 4.97,
                      reviewCount: 156,
                      imageUrl:
                          "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                      onTap: () {},
                      onFavoriteChanged: (value) {},
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                )),
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
              username: user?.name,
            )),
        Positioned(bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
      ])),
    );
  }
}
