import '../data_source/remote_data_source/home_remote.dart';
import '../model/home_model.dart';

abstract class HomeRepository {
  Future<List<HomeModel>> getRooms();
  Future<List<HomeModel>> getAvailableRooms({
    required String checkIn,
    required String checkOut,
    String? roomType,
  });
  Future<HomeModel?> getRoomById(String id);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HomeModel>> getRooms() async {
    return await remoteDataSource.getRooms();
  }

  @override
  Future<List<HomeModel>> getAvailableRooms({
    required String checkIn,
    required String checkOut,
    String? roomType,
  }) async {
    return await remoteDataSource.getAvailableRooms(
      checkIn: checkIn,
      checkOut: checkOut,
      roomType: roomType,
    );
  }

  @override
  Future<HomeModel?> getRoomById(String id) async {
    final rooms = await getRooms();
    try {
      return rooms.firstWhere((room) => room.roomId == id);
    } catch (e) {
      return null;
    }
  }
}