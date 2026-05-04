import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/order_model.dart';

class OrderService extends ChangeNotifier {
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('Orders')
          .add(order.toMap());
      await fetchOrders(userId);
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<OrderModel>> fetchOrders(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('Orders')
        .get();
    _orders = snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
        .toList();
    notifyListeners();
    return _orders;
  }

  Future<void> updateStatus(
    String userId,
    String orderId,
    OrderStatus status,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('Orders')
          .doc(orderId)
          .update({'Status': status.name});
    } catch (e) {
      throw Exception(e.toString());
    }
    notifyListeners();
  }

  Future<void> cancelOrder(String userId, String orderId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('Orders')
          .doc(orderId)
          .update({"Status": OrderStatus.cancelled.name});
      await fetchOrders(userId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
