// Entity ของ Room หน้า home page
class HomeEntitise {
  final int roomId;
  final String roomType;
  final String description;
  final int pricePerNight;
  final List<String> imageUrls;
  final int bedCount;
  final String status;

  HomeEntitise({
    required this.roomId,
    required this.roomType,
    required this.description,
    required this.pricePerNight,
    required this.imageUrls,
    required this.bedCount,
    required this.status,
  });
}


class RoomTypeEntitise {

}