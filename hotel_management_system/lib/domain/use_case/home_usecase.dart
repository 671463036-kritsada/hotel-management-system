import 'package:hotel_management_system/data/model/home_model.dart';
import 'package:hotel_management_system/data/repositorise/home_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/home_entitise.dart';

class HomeUsecase {
  final HomeRepositoryImpl repository;
  HomeUsecase(this.repository);

  HomeEntitise _toEntity(HomeModel item) {
    return HomeEntitise(
      roomId: item.roomId ?? '',
      roomType: item.roomType ?? "",
      description: item.description ?? "",
      pricePerNight: double.tryParse(item.pricePerNight ?? '') ?? 0.0,
      imageUrls: item.imageUrl != null ? [item.imageUrl!] : <String>[],
      bedCount: 1,
      status: item.status ?? "",
    );
  }

  Future<List<HomeEntitise>> getRooms() async {
    try {
      final model = await repository.getRooms();
      return model.map(_toEntity).toList();
    } catch (e) {
      throw Exception("error home usecase: $e");
    }
  }

  Future<List<HomeEntitise>> getAvailableRooms({
    required String checkIn,
    required String checkOut,
    String? roomType,
  }) async {
    try {
      final model = await repository.getAvailableRooms(
        checkIn: checkIn,
        checkOut: checkOut,
        roomType: roomType,
      );
      return model.map(_toEntity).toList();
    } catch (e) {
      throw Exception("error home usecase (available rooms): $e");
    }
  }
}
