// room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../../../../util/widget/core/typeRoom_enum.dart';
import '../provider/room_detail_screen_provider.dart';

class RoomDetailScreenMobileBody extends StatefulWidget {
  final String roomId;
  final RoomType roomType;

  const RoomDetailScreenMobileBody(
      {super.key, required this.roomId, required this.roomType});

  @override
  State<RoomDetailScreenMobileBody> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreenMobileBody> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<RoomDetailScreenProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage.isNotEmpty) {
              return Center(child: Text(provider.errorMessage));
            }

            final room = provider.roomDetail;
            if (room == null) return const SizedBox.shrink();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Topnavbar(widthFactor: 0.2, username: user?.name),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "รายละเอียด ${room.roomType == RoomType.rooms ? 'ห้องพัก' : 'บ้านพัก'}",
                      style: TextStyle(fontSize: Constants.fontSizeHeader),
                    ),
                  ),
                  RoomImageSlider(imageUrls: room.imageUrls),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'ห้องหมายเลข ${room.roomId}',
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color:
                                      Constants.secondaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    room.roomType == RoomType.rooms
                                        ? 'Standard Room'
                                        : 'Private House',
                                    style: const TextStyle(
                                        color: Constants.secondaryColor,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '฿${room.pricePerNight.toDouble()} / คืน',
                          style: const TextStyle(
                              fontSize: 22,
                              color: Constants.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 40),
                        const Text(
                          'รายละเอียดที่พัก',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          room.description,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey, height: 1.5),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Button(
                            text: 'จองห้องนี้',
                            onTap: () {
                              Navigator.pushNamed(context, "/booking_form",
                                  arguments: room.roomId);
                            },
                            color: Constants.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- RoomImageSlider ---
class RoomImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  const RoomImageSlider({super.key, required this.imageUrls});

  @override
  State<RoomImageSlider> createState() => _RoomImageSliderState();
}

class _RoomImageSliderState extends State<RoomImageSlider> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 300.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: widget.imageUrls.map((imageUrl) {
            return Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.primaryColor
                      .withOpacity(_current == entry.key ? 0.9 : 0.3),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
