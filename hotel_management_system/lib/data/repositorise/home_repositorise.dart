import '../data_source/remote_data_source/home_remote.dart';
import '../model/home_model.dart';

abstract class HomeRepository {
  Future<List<HomeModel>> getRooms();
  Future<HomeModel?> getRoomById(int id);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HomeModel>> getRooms() async {
    final roomsData = await remoteDataSource.getRooms();
    return roomsData
        .map((item) => HomeModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<HomeModel?> getRoomById(int id) async {
    final rooms = await getRooms();
    return rooms.cast<HomeModel?>().firstWhere(
          (room) => room?.roomId == id,
          orElse: () => null,
        );
  }
}
