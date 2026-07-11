import '../../domain/entitise/housekeeper_room_entity.dart';
import '../data_source/remote_data_source/houseKeeper_remote.dart';

abstract class HousekeeperRoomRepository {
  Future<List<HousekeeperRoomEntity>> getRooms();
  Future<bool> saveRoomDetail({
    required String roomNo,
    required String cleaningStatus,
  });
}

class HousekeeperRoomRepositoryImpl implements HousekeeperRoomRepository {
  final HousekeeperRoomRemoteDataSource remoteDataSource;

  HousekeeperRoomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HousekeeperRoomEntity>> getRooms() async {
    try {
      final List<Map<String, dynamic>> rawData =
          await remoteDataSource.getRooms();

      return rawData.map((item) {
        return HousekeeperRoomEntity(
          roomNo: item["roomNo"] as String,
          status: item["status"] as String,
        );
      }).toList();
    } catch (e) {
      throw Exception("Repository error: $e");
    }
  }

  @override
  Future<bool> saveRoomDetail({
    required String roomNo,
    required String cleaningStatus,
  }) async {
    try {
      return await remoteDataSource.saveRoomDetail(
        roomNo: roomNo,
        cleaningStatus: cleaningStatus,
      );
    } catch (e) {
      throw Exception("Repository error: $e");
    }
  }
}
