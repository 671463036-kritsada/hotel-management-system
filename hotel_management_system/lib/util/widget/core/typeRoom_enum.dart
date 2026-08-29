import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/home_entitise.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';

import '../../model/model.dart';

enum RoomType {
  rooms,
  house,
}

Widget createBoxShowData(
  RoomType type,
  List<HomeEntitise> rooms, {
  int len = 10,
  int crossAxisCount = 2,
}) {
  final filteredRooms = rooms
      .where((room) {
        final selectedType = type == RoomType.rooms ? 'rooms' : 'house';
        return room.roomType.toLowerCase() == selectedType;
      })
      .take(len)
      .toList();

  if (filteredRooms.isEmpty) {
    return const Center(child: Text('ไม่มีข้อมูล'));
  }

  return GridView.builder(
    padding: const EdgeInsets.only(bottom: 12),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.78,
    ),
    itemCount: filteredRooms.length,
    itemBuilder: (context, index) {
      final room = filteredRooms[index];
      final imagePath = room.imageUrls.isNotEmpty
          ? room.imageUrls.first
          : 'assets/images/rooms/room1.jpg';

      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/room_detail',
              arguments: RoomDetailArguments(
                  roomId: room.roomId, roomType: room.roomType));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image_not_supported_outlined),
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image_not_supported_outlined),
                              ),
                            );
                          },
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.roomType.toLowerCase() == 'house'
                          ? 'บ้านพัก'
                          : 'ห้องพัก',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      bedCount: room.bedCount,
                      // status: room.status,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '฿${room.pricePerNight}',
                      style: const TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildInfoRow({required int bedCount}) {
  return Row(
    children: [
      Icon(Icons.king_bed_outlined, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 4),
      Text('$bedCount เตียง',
          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      const SizedBox(width: 10),
      Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 4),
      // Text(
      //   status,
      //   style: TextStyle(
      //     fontSize: 12,
      //     color: status == 'ว่าง' ? Colors.green[600] : Colors.orange[700],
      //   ),
      // ),
    ],
  );
}
