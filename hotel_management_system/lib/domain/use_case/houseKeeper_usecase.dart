import '../../data/repositorise/houseKeeper_repositorise.dart';
import '../entitise/housekeeper_room_entity.dart';

class HousekeeperRoomUseCase {
  final HousekeeperRoomRepository repository;

  HousekeeperRoomUseCase({required this.repository});

  Future<List<HousekeeperRoomEntity>> getRooms() async {
    return await repository.getRooms();
  }

  Future<bool> saveRoomDetail({
    required String roomNo,
    required String cleaningStatus,
  }) async {
    try {
      return await repository.saveRoomDetail(
        roomNo: roomNo,
        cleaningStatus: cleaningStatus,
      );
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }
}
