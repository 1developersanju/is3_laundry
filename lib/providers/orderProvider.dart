import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/orderModel.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Orders> _orders = [];

  List<Orders> get orders => _orders;

  OrderProvider() {
    fetchOrders();
  }

  Future<void> createOrder(Orders order) async {
    try {
      DocumentReference docRef = await _firestore.collection('orders').add(order.toMap());
      // Optionally update the order ID if needed
      // order.id = docRef.id;
      notifyListeners();
    } catch (e) {
      print('Error creating order: $e');
      throw e;
    }
  }

  Future<void> fetchOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('orders').get();
      _orders = snapshot.docs.map((doc) => Orders.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }
}
