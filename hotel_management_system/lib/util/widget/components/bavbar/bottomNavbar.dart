import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/widget/components/button/buttonIcon.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';

class Bottomnavbar extends StatelessWidget {
  final bool? isVisibleHousekeeper;
  const Bottomnavbar({super.key, this.isVisibleHousekeeper = true});

  void navigateToHome(BuildContext context) =>
      Navigator.pushNamed(context, "/home");

  void navigateToList(BuildContext context) =>
      Navigator.pushNamed(context, "/list_page");

  void navigateToHistory(BuildContext context) =>
      Navigator.pushNamed(context, "/history");
      
  void housekeeperRoomCheck_Screen(BuildContext context) =>
      Navigator.pushNamed(context, "/housekeeper");

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
          if (isVisibleHousekeeper ?? true)
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
