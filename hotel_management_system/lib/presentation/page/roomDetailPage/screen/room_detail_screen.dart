// room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/typeRoom_enum.dart';
import 'roomDetailScreen_desktopBody.dart';
import 'roomDetailScreen_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';
import '../provider/room_detail_screen_provider.dart';

class RoomDetailScreen extends StatefulWidget {
  final int roomId;
  final RoomType roomType;

  const RoomDetailScreen({
    super.key,
    required this.roomId,
    required this.roomType
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
            widget.roomType
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
      ),
      desktopBody: RoomDetailScreenDesktopBody(
        roomId: widget.roomId,
        roomType: widget.roomType,
      ),
     );
  }
}
