import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/HousekeeperRoomCheckPage/HousekeeperRoomCheck_Screen.dart';
import 'package:hotel_management_system/presentation/components/button/buttonIcon.dart';
import 'package:hotel_management_system/presentation/core/constants.dart';
import 'package:hotel_management_system/presentation/historyPage/history_screen.dart';
import 'package:hotel_management_system/presentation/homePage/home_screen.dart';
import 'package:hotel_management_system/presentation/listPage/list_screen.dart';

class Bottomnavbar extends StatelessWidget {
  const Bottomnavbar({super.key});

  // ฟังก์ชัน Navigation (เหมือนเดิม)
  void navigateToHome(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  void navigateToList(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ListScreen(checkInStatus: false)));
  void navigateToHistory(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => HistoryScreen()));
  void housekeeperRoomCheck_Screen(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const HousekeeperRoomCheckScreen()));

  @override
  Widget build(BuildContext context) {
    return Container(
      // ปรับ padding แนวนอนให้เล็กลงเพื่อลดการบีบปุ่ม
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Constants.borderRadius),
          topRight: Radius.circular(Constants.borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ใช้ Expanded หุ้มทุกปุ่มเพื่อให้กว้างเท่ากัน
          Expanded(
            child: Buttonicon(
                onTap: () => navigateToHome(context),
                text: "หน้าแรก",
                icon: Icons.home_outlined),
          ),
          Expanded(
            child: Buttonicon(
                onTap: () => navigateToList(context),
                text: "รายการ",
                icon: Icons.list_alt_outlined),
          ),
          Expanded(
            child: Buttonicon(
                onTap: () => navigateToHistory(context),
                text: "ประวัติ",
                icon: Icons.history_outlined),
          ),
          Expanded(
            child: Buttonicon(
                onTap: () => housekeeperRoomCheck_Screen(context),
                text: "แม่บ้าน",
                icon: Icons.cleaning_services_outlined),
          ),
        ],
      ),
    );
  }
}
