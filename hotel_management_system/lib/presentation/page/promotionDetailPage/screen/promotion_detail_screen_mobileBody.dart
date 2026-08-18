import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:hotel_management_system/util/widget/components/bavbar/bottomNavbar.dart';
import 'package:hotel_management_system/util/widget/components/bavbar/topNavbar.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/core/constants.dart';

class PromotionDetailScreenMobilebody extends StatefulWidget {
  const PromotionDetailScreenMobilebody({super.key});

  @override
  State<PromotionDetailScreenMobilebody> createState() =>
      _PromotionDetailScreenMobilebodyState();
}

class _PromotionDetailScreenMobilebodyState
    extends State<PromotionDetailScreenMobilebody> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),

              // รูปข่าว
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Image.network(
                  "https://www.amarinsamuiresort.com/images/promotion/banner-promotion-amarin-1.jpg",
                  fit: BoxFit.cover,
                ),
              ),

              // รายละเอียด
              Padding(
                padding: const EdgeInsets.all(
                  Constants.padding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "รายละเอียดข่าวสาร",
                      style: TextStyle(
                        fontSize: Constants.fontSizeHeader,
                        fontWeight: Constants.fontWeightBold,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // หัวข้อข่าว
                    Text(
                      "โปรโมชั่นพิเศษสำหรับลูกค้าของเรา",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    // วันที่
                    Text(
                      "เผยแพร่วันที่ 11 สิงหาคม 2569",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // เนื้อหาข่าว
                    Text(
                      "ทางโรงแรมขอมอบโปรโมชั่นพิเศษสำหรับลูกค้าทุกท่าน "
                      "พบกับส่วนลดค่าห้องพักและสิทธิพิเศษมากมาย "
                      "เพื่อให้การเข้าพักของคุณเต็มไปด้วยความประทับใจ",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Text(
                      "สิทธิพิเศษ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      "• ลดค่าห้องพักสูงสุด 20%\n"
                      "• ฟรีอาหารเช้าสำหรับ 2 ท่าน\n"
                      "• ฟรี Welcome Drink\n"
                      "• สามารถใช้บริการได้ตลอดช่วงโปรโมชั่น",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.8,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Text(
                      "เงื่อนไขการใช้บริการ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      "โปรโมชั่นนี้สามารถใช้ได้ตั้งแต่วันที่ 1 สิงหาคม "
                      "ถึง 31 สิงหาคม 2569 และไม่สามารถใช้ร่วมกับโปรโมชั่นอื่นได้",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
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
      ])),
    );
  }
}
