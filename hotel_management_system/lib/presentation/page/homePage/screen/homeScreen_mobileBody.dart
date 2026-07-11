// home_screen.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../components/bavbar/bottomNavbar.dart';
import '../../../components/bavbar/topNavbar.dart';
import '../../../core/constants.dart';
import '../../../core/form_enum.dart';
import '../../../core/typeRoom_enum.dart';
import '../provider/home_screen_provider.dart';

class HomeScreenMobileBody extends StatefulWidget {
  const HomeScreenMobileBody({super.key});

  @override
  State<HomeScreenMobileBody> createState() => _HomeScreenMobileBodyState();
}

class _HomeScreenMobileBodyState extends State<HomeScreenMobileBody> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<HomeScreenProvider>().getRoomdata();
    });
  }

  Widget _buildTabButton(BuildContext context, String label, RoomType type) {
    final provider = context.watch<HomeScreenProvider>();
    bool isSelected = provider.selectedRoomType == type;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Constants.primaryColor : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () => context.read<HomeScreenProvider>().selectRoomType(type),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Topnavbar(
                  widthFactor: 0.2,
                  username: context.read<UserProvider>().username,
                )),
            Positioned(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 83),
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Row(
                      children: [
                        Expanded(
                            child: createInputField(InputFieldType.search)),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Constants.secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.search,
                                color: Constants.white, size: 35),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildTabButton(context, "ห้องพัก", RoomType.rooms),
                        const SizedBox(width: 10),
                        _buildTabButton(context, "บ้านพัก", RoomType.house),
                      ],
                    ),
                    SizedBox(height: 8),
                    Consumer<HomeScreenProvider>(
                        builder: (context, provider, child) {
                      return Expanded(
                        child: provider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : provider.errorMessage.isNotEmpty
                                ? Center(child: Text(provider.errorMessage))
                                : createBoxShowData(
                                    provider.selectedRoomType,
                                    provider.roomData,
                                    len: provider.len,
                                    crossAxisCount: 2,
                                  ),
                      );
                    })
                  ],
                ),
              ),
            ),
            Positioned(bottom: 0, right: 0, left: 0, child: Bottomnavbar()),
          ],
        ),
      ),
    );
  }
}
