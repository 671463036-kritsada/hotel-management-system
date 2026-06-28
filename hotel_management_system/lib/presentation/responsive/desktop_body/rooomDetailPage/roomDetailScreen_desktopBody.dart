// room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hotel_management_system/presentation/responsive/page/BookingFormScreen/booking_form_screen.dart';
import 'package:provider/provider.dart';

import '../../../components/bavbar/topNavbar.dart';
import '../../../components/button/button.dart';
import '../../../core/constants.dart';
import '../../../core/typeRoom_enum.dart';
import '../../page/roomDetailPage/room_detail_screen_provider.dart';

class RoomDetailScreenDesktopBody extends StatefulWidget {
  final int roomId;
  final RoomType roomType;
  final List<String> imageUrls;

  const RoomDetailScreenDesktopBody({
    super.key,
    required this.roomId,
    required this.roomType,
    required this.imageUrls,
  });

  @override
  State<RoomDetailScreenDesktopBody> createState() =>
      _RoomDetailScreenDesktopState();
}

class _RoomDetailScreenDesktopState extends State<RoomDetailScreenDesktopBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoomDetailScreenProvider>().getRoomDetail(
            widget.roomId,
            widget.roomType,
            widget.imageUrls,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgcolor,
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
                  Topnavbar(widthFactor: 0.1),

                  // --- Slider เต็มความกว้าง ---
                  RoomImageSlider(imageUrls: room.imageUrls),

                  // --- Content area ---
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Left: ข้อมูลหลัก ---
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ห้องหมายเลข ${room.roomId}',
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Constants.secondaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      room.roomType == RoomType.rooms
                                          ? 'Standard Room'
                                          : 'Private House',
                                      style: const TextStyle(
                                          color: Constants.secondaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Divider(),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'รายละเอียดที่พัก',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    room.description,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        height: 1.8),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 32),

                            // --- Right: ราคา + ปุ่มจอง ---
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('ราคาต่อคืน',
                                        style: TextStyle(color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '฿${room.pricePerNight.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                          fontSize: 32,
                                          color: Constants.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Button(
                                        text: 'จองห้องนี้',
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookingFormScreen(
                                                          roomId:
                                                              room.roomId)));
                                        },
                                        color: Constants.secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // --- Slider ---
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: screenWidth * 0.35,
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() => _current = index);
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

        // --- Dot indicators ทับบนรูป ---
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageUrls.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _current == entry.key ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white
                        .withOpacity(_current == entry.key ? 1.0 : 0.5),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
