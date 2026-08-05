import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/responseModelRemote/response_model.dart';

abstract class ListRemoteDatasource {
  Future<List<Map<String, dynamic>>> getListData();
}


class ListRemoteDatasourceImpl implements ListRemoteDatasource {

  final Dio dio;

  static const String _endpoint = 'bookings/my-bookings';


  ListRemoteDatasourceImpl(this.dio);


  @override
  Future<List<Map<String, dynamic>>> getListData() async {

    try {

      final response = await dio.get(
        _endpoint,
      );


      final ResponseModel responseModel =
          ResponseModel.fromJson(
            response.data as Map<String,dynamic>,
          );


      if(responseModel.isSuccess){

        final data = responseModel.data;


        if(data is List){

          return data
              .whereType<Map>()
              .map(
                (item)=>Map<String,dynamic>.from(item),
              )
              .toList();

        }


        throw Exception(
          "Invalid booking data format",
        );

      }else{

        throw Exception(
          responseModel.message ?? "Failed load data",
        );

      }


    } on DioException catch(e){

      if(e.response?.statusCode == 401){

        throw Exception(
          "Token หมดอายุ",
        );

      }


      throw Exception(
        e.message ?? "Network error",
      );


    }

  }

}