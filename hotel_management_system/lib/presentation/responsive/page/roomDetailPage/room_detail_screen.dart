// room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/typeRoom_enum.dart';
import '../../desktop_body/rooomDetailPage/roomDetailScreen_desktopBody.dart';
import '../../mobile_body/roomDetailPageMobile/roomDetailScreen_mobileBody.dart';
import '../../responsive_layout.dart';
import 'room_detail_screen_provider.dart';

class RoomDetailScreen extends StatefulWidget {
  final int roomId;
  final RoomType roomType;
  final List<String> imageUrls;

  const RoomDetailScreen({
    super.key,
    required this.roomId,
    required this.roomType,
    required this.imageUrls,
  });

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
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
    return 
     ResponsiveLayout(
      mobileBody: RoomDetailScreenMobileBody(
        roomId: widget.roomId,
        roomType: widget.roomType,
        imageUrls: widget.imageUrls,
      ),
      desktopBody: RoomDetailScreenDesktopBody(
        roomId: widget.roomId,
        roomType: widget.roomType,
        imageUrls: widget.imageUrls,
      ),
     );
  }
}
