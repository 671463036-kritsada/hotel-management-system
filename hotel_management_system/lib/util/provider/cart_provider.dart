import 'package:flutter/material.dart';
import 'package:hotel_management_system/data/model/cart_item_model.dart';
import 'package:hotel_management_system/util/widget/core/network/dio_client.dart';

import '../../domain/entitise/cart_item_entitise.dart';
import '../widget/core/constants.dart';

/// เก็บรายการห้องพักที่ผู้ใช้เลือกไว้ในตะกร้า ให้เข้าถึงได้ทุกหน้า (global provider)
class CartProvider extends ChangeNotifier {
  final List<CartItemEntitise> _items = [];

  List<CartItemEntitise> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.length;

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get depositAmount => totalPrice * Constants.depositPercent;

  double get remainingAmount => totalPrice - depositAmount;

  Future<void> load() async {
    final response = await DioClient.dio.get('cart');
    final data = response.data['data'];
    if (data is! List) return;
    _items
      ..clear()
      ..addAll(data.whereType<Map>().map((item) =>
          CartItemModel.fromJson(Map<String, dynamic>.from(item)).toEntity()));
    notifyListeners();
  }

  Future<void> addItem(CartItemEntitise item) async {
    final response = await DioClient.dio.post('cart', data: {
      'roomId': item.roomId,
      'checkIn': item.checkIn.toIso8601String(),
      'checkOut': item.checkOut.toIso8601String(),
      'adultCount': item.adultCount,
      'childCount': item.childCount,
      'extraBedTypeId': item.extraBedType?.id,
      'extraBedQuantity': item.extraBedQuantity,
    });
    final id = response.data['data']?['id'];
    _items.add(CartItemEntitise(
      id: int.tryParse('$id') ?? item.id,
      roomId: item.roomId,
      roomType: item.roomType,
      imageUrl: item.imageUrl,
      checkIn: item.checkIn,
      checkOut: item.checkOut,
      adultCount: item.adultCount,
      childCount: item.childCount,
      extraBedType: item.extraBedType,
      extraBedQuantity: item.extraBedQuantity,
      pricePerNight: item.pricePerNight,
    ));
    notifyListeners();
  }

  Future<void> removeItem(int id) async {
    await DioClient.dio.delete('cart/$id');
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> clear() async {
    await DioClient.dio.delete('cart');
    _items.clear();
    notifyListeners();
  }
}
