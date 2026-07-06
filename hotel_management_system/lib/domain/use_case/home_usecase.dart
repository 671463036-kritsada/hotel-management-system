
import 'package:hotel_management_system/data/repositorise/home_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/home_entitise.dart';

class HomeUsecase {
  final HomeRepositoryImpl repository ;
  HomeUsecase(this.repository);

   Future<List<HomeEntitise>> getRooms() async {
    try {
      final model = await repository.getRooms();

      return model.map((item) => HomeEntitise(
        roomId: item.roomId ?? -1,
        roomType: item.roomType ?? "",
        description: item.description ?? "",
        pricePerNight: (item.pricePerNight ?? 0).toDouble(),
        imageUrls: List<String>.from(item.imageUrls!),
        bedCount: 1,
        status: item.status ?? "",
      )).toList();

    } catch (e) {
      throw Exception("error home usecase: $e");
    }
  }
}

