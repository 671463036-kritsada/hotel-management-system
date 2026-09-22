import '../../domain/entitise/cart_item_entitise.dart';
import '../../domain/entitise/extra_bed_entitise.dart';
import '../../util/function/image_url.dart';
import '../../util/widget/core/typeRoom_enum.dart';

class CartItemModel {
  final int id;
  final String roomId;
  final RoomType roomType;
  final String? imageUrl;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adultCount;
  final int childCount;
  final ExtraBedTypeEntitise? extraBedType;
  final int extraBedQuantity;
  final double pricePerNight;
  final double roomPrice;
  final double extraBedPrice;

  CartItemModel({
    required this.id,
    required this.roomId,
    required this.roomType,
    this.imageUrl,
    required this.checkIn,
    required this.checkOut,
    required this.adultCount,
    required this.childCount,
    this.extraBedType,
    required this.extraBedQuantity,
    required this.pricePerNight,
    required this.roomPrice,
    required this.extraBedPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final roomType = json['room_type']?.toString() == 'house'
        ? RoomType.house
        : RoomType.rooms;
    final pricePerNight =
        double.tryParse('${json['price_per_night'] ?? 0}') ?? 0;
    return CartItemModel(
      id: int.parse('${json['id']}'),
      roomId: '${json['room_id']}',
      roomType: roomType,
      imageUrl: ImageUrlHelper.toFullImageUrl(json['image_url']?.toString()),
      checkIn: DateTime.parse('${json['check_in']}'),
      checkOut: DateTime.parse('${json['check_out']}'),
      adultCount: int.tryParse('${json['adult_count'] ?? 1}') ?? 1,
      childCount: int.tryParse('${json['child_count'] ?? 0}') ?? 0,
      extraBedType: json['extra_bed_type_id'] == null
          ? null
          : ExtraBedTypeEntitise(
              id: int.parse('${json['extra_bed_type_id']}'),
              name: '${json['extra_bed_name'] ?? ''}',
              description: '${json['extra_bed_description'] ?? ''}',
              price:
                  double.tryParse('${json['extra_bed_unit_price'] ?? 0}') ?? 0,
              maxChildAge:
                  int.tryParse('${json['extra_bed_max_child_age'] ?? 0}') ?? 0,
            ),
      extraBedQuantity: int.tryParse('${json['extra_bed_quantity'] ?? 0}') ?? 0,
      pricePerNight: pricePerNight,
      roomPrice: double.tryParse('${json['room_price'] ?? 0}') ?? 0,
      extraBedPrice: double.tryParse('${json['extra_bed_price'] ?? 0}') ?? 0,
    );
  }

  CartItemEntitise toEntity() => CartItemEntitise(
        id: id,
        roomId: roomId,
        roomType: roomType,
        imageUrl: imageUrl,
        checkIn: checkIn,
        checkOut: checkOut,
        adultCount: adultCount,
        childCount: childCount,
        extraBedType: extraBedType,
        extraBedQuantity: extraBedQuantity,
        pricePerNight: pricePerNight,
      );
}
