import 'dart:io';

import 'package:hotel_management_system/data/repositorise/furniture_repositorise.dart';
import 'package:hotel_management_system/data/model/furniture_model.dart';
import 'package:hotel_management_system/domain/entitise/furniture_entitise.dart';

class FurnitureUsecase {
  final FurnitureRepositoriseImpl repository;

  FurnitureUsecase(this.repository);

  // ============================================================
  // GET FURNITURE
  // ============================================================

  Future<List<FurnitureEntitise>> getFurnitureData(
    String roomID,
    String bookingId,
  ) async {
    try {
      final modelData = await repository.getFurnitureData(roomID, bookingId);

      return modelData.map((item) {
        return FurnitureEntitise(
          id: item.id,
          roomID: roomID,
          bookingId: bookingId,
          title: item.title,
          image: item.image,
          isCustom: item.isCustom ?? false,

          // สถานะล่าสุดของแม่บ้าน
          status: "ยังไม่ได้ตรวจสอบ",

          // Note ของแม่บ้าน
          note: null,

          // รูปความเสียหายของ user รอบนี้
          damageImage: null,

          // รูปที่แม่บ้านตรวจล่าสุด
          housekeeperInspectionImage: item.housekeeperInspectionImage,
        );
      }).toList();
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
  // Future<List<FurnitureEntitise>> getFurnitureData(
  //   String roomID,
  //   String bookingId,
  // ) async {
  //   try {
  //     final modelData =
  //         await repository.getFurnitureData(roomID, bookingId);

  //     return modelData.map((item) {
  //       final housekeeperInspection = item.inspections
  //           ?.where(
  //             (i) =>
  //                 i.inspectorRole?.trim().toLowerCase() ==
  //                 'housekeeper',
  //           )
  //           .lastOrNull;

  //       return FurnitureEntitise(
  //         id: item.id,
  //         roomID: roomID,
  //         bookingId: bookingId,
  //         title: item.title,
  //         image: item.image,
  //         isCustom: item.isCustom ?? false,

  //         // สถานะล่าสุดของแม่บ้าน
  //         status: housekeeperInspection?.status ?? "ยังไม่ได้ตรวจสอบ",

  //         // Note ของแม่บ้าน
  //         note: housekeeperInspection?.note,

  //         // รูป inspection ของ user รอบก่อน
  //         damageImage: null,

  //         // สำคัญ:
  //         // รูปที่แม่บ้านตรวจล่าสุด
  //         housekeeperInspectionImage:
  //             housekeeperInspection?.damageImage,
  //       );
  //     }).toList();
  //   } on SocketException {
  //     throw Exception("ไม่มีการเชื่อมต่อ internet");
  //   } on HttpException {
  //     throw Exception("ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้");
  //   } catch (e) {
  //     throw Exception("เกิดข้อผิดพลาด $e");
  //   }
  // }

  // ============================================================
  // SUBMIT FURNITURE REPORT
  // ============================================================

  Future<bool> submitReport(
    List<FurnitureEntitise> reportData,
    String bookingId,
    Map<String, File> photosByField,
  ) async {
    try {
      final reportModels = reportData.map((e) {
        return FurnitureModel(
          id: e.id,
          roomId: e.roomID,
          bookingId: bookingId,
          title: e.title,
          image: e.image,
          isCustom: e.isCustom,
          inspections: [
            Inspection(
              status: e.status,
              note: e.note,
              damageImage: e.damageImage,
              inspectedAt: DateTime.now(),
            ),
          ],
        );
      }).toList();

      return await repository.submitReport(
        reportModels,
        photosByField,
      );
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}

// import 'dart:io';
// import 'package:hotel_management_system/data/repositorise/furniture_repositorise.dart';
// import 'package:hotel_management_system/data/model/furniture_model.dart';
// import 'package:hotel_management_system/domain/entitise/furniture_entitise.dart';

// class FurnitureUsecase {
//   final FurnitureRepositoriseImpl repository;
//   FurnitureUsecase(this.repository);

//   Future<List<FurnitureEntitise>> getFurnitureData(
//       String roomID, String bookingId) async {
//     try {
//       final modelData =
//           await repository.getFurnitureData(roomID, bookingId);
//       return modelData.map((item) {
//         final housekeeperInspection = item.inspections
//             ?.where((i) => i.inspectorRole == 'housekeeper')
//             .lastOrNull;
//         return FurnitureEntitise(
//           id: item.id,
//           roomID: roomID,
//           bookingId: bookingId,
//           title: item.title,
//           image: item.image,
//           isCustom: item.isCustom ?? false,
//           status: housekeeperInspection?.status ?? "ยังไม่ได้ตรวจสอบ",
//           // ✅ เพิ่มกลับเข้ามา: ต้องส่งโน้ต/รูปที่แม่บ้านตรวจไว้มาด้วย ไม่งั้น
//           // user เปิดหน้าตรวจสภาพห้องแล้วจะไม่เห็นหลักฐานที่แม่บ้านถ่ายไว้เลย
//           // ทั้งที่ flow ต้องการให้ user เห็นรูปนี้เพื่อตรวจซ้ำก่อน check-in
//           note: housekeeperInspection?.note,
//           damageImage: housekeeperInspection?.damageImage,
//         );
//       }).toList();
//     } on SocketException {
//       throw Exception("ไม่มีการเชื่อมต่อ internet");
//     } on HttpException {
//       throw Exception("ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้");
//     } catch (e) {
//       throw Exception("เกิดข้อผิดพลาด $e");
//     }
//   }

//   // ✅ เพิ่ม photosByIndex ให้ตรงกับ repository.submitReport ตัวใหม่ที่ส่ง
//   // multipart แทน JSON ธรรมดา — index ในนี้ต้องตรงกับตำแหน่งใน reportData
//   // เป๊ะ เพราะ backend จับคู่ไฟล์กับ item ด้วย index ของ items array
//   Future<bool> submitReport(
//     List<FurnitureEntitise> reportData,
//     String bookingId,
//     Map<int, File> photosByIndex,
//   ) async {
//     try {
//       final reportModels = reportData.map((e) {
//         return FurnitureModel(
//           id: e.id,
//           roomId: e.roomID,
//           bookingId: bookingId,
//           title: e.title,
//           image: e.image,
//           isCustom: e.isCustom,
//           inspections: [
//             Inspection(
//               status: e.status,
//               note: e.note,
//               damageImage: e.damageImage,
//               inspectedAt: DateTime.now(),
//             )
//           ],
//         );
//       }).toList();
//       return await repository.submitReport(reportModels, photosByIndex);
//     } on SocketException {
//       throw Exception("ไม่มีการเชื่อมต่อ internet");
//     } on HttpException {
//       throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
//     } catch (e) {
//       throw Exception("เกิดข้อผิดพลาด $e");
//     }
//   }

//   // ✅ เพิ่มใหม่: user แจ้งชำรุดผ่าน endpoint เดียวกับแม่บ้าน (/housekeeper/issues)
//   // backend เปิด isUserOrHousekeeper ไว้รับทั้งสอง role อยู่แล้ว ไม่ต้องมี
//   // endpoint แยกสำหรับ user โดยเฉพาะ
//   Future<bool> createRepairReport({
//     required String roomNo,
//     required String issueType,
//     required String description,
//     required List<File> imageFiles,
//   }) async {
//     try {
//       return await repository.createRepairReport(
//         roomNo: roomNo,
//         issueType: issueType,
//         description: description,
//         imageFiles: imageFiles,
//       );
//     } catch (e) {
//       throw Exception("UseCase error: $e");
//     }
//   }
// }