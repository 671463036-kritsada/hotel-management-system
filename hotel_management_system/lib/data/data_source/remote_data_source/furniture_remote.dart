abstract class furnitureRemoteDataSource {
  Future<List<Map<String, dynamic>>> getFurnitureData();
}

class furnitureRemoteDataSourceImpl implements furnitureRemoteDataSource {
  @override
  Future<List<Map<String, dynamic>>> getFurnitureData() async {
    final furnitureMockData = {
      "statusCode": 200,
      "data": [
        {
          "title": "เตียงนอน",
          "image": "assets/images/furnitures/bed.jpg",
          "status": "ปกติ"
        },
        {
          "title": "เครื่องปรับอากาศ",
          "image": "assets/images/furnitures/airconditioner.jpg",
          "status": "ปกติ"
        },
        {
          "title": "ตู้เย็น / มินิบาร์",
          "image": "assets/images/furnitures/fridge.jpg",
          "status": "ปกติ"
        },
        {
          "title": "ทีวี และ รีโมท",
          "image": "assets/images/furnitures/TV.jpg",
          "status": "ปกติ"
        },
        {
          "title": "โซฟา / เก้าอี้",
          "image": "assets/images/furnitures/sofa.jpg",
          "status": "ปกติ"
        },
        {
          "title": "โต๊ะทำงาน",
          "image": "assets/images/furnitures/desk.jpg",
          "status": "ปกติ"
        },
        {
          "title": "ตู้เสื้อผ้า",
          "image": "assets/images/furnitures/wardrobe.jpg",
          "status": "ปกติ"
        },
        {
          "title": "กระจก",
          "image": "assets/images/furnitures/mirror.jpg",
          "status": "ปกติ"
        },
        {
          "title": "ไดร์เป่าผม",
          "image": "assets/images/furnitures/hairdryer.jpg",
          "status": "ปกติ"
        },
        {
          "title": "กาต้มน้ำ",
          "image": "assets/images/furnitures/kettle.jpg",
          "status": "ปกติ"
        },
        {
          "title": "เครื่องนอน / ผ้าปูที่นอน",
          "image": "assets/images/furnitures/bedding.jpg",
          "status": "ปกติ"
        },
        {
          "title": "ประตูและกุญแจ",
          "image": "assets/images/furnitures/door.jpg",
          "status": "ปกติ"
        }
      ]
    };

    try {
      await Future.delayed( const Duration(milliseconds: 300));
      if (furnitureMockData["statusCode"] == 200) {
        return furnitureMockData["data"] as List<Map<String, dynamic>>;
      } else {
        throw Exception("Failed to load furniture");
      }
    } catch (e) {
      throw Exception("Failed to fetch funiture: $e");
    }
  }
}
