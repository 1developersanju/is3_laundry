import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  final String id;
  final String serviceType;
  final String location;
  final String status;
  final double price;
  final DateTime date;
  final double weight;
  final String phoneNumber;
  final String shopName;
  final String shopid;

  Orders({
    required this.id,
    required this.serviceType,
    required this.location,
    required this.status,
    required this.price,
    required this.date,
    required this.weight,
    required this.phoneNumber,
    required this.shopName,
    required this.shopid
  });

  factory Orders.fromFirestore(Map<String, dynamic> data, String id) {
    return Orders(
      id: id,
      serviceType: data['serviceType'] ?? '',
      location: data['location'] ?? '',
      status: data['status'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp).toDate(),
      weight: data['weight']?.toDouble() ?? 0.0,
      phoneNumber: data['phoneNumber'] ?? '',
      shopName: data['shopName']??'',
      shopid: data['shopId']??''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceType': serviceType,
      'location': location,
      'status': status,
      'price': price,
      'date': date,
      'weight': weight,
      'phoneNumber': phoneNumber,
      'shopName':shopName,
      'shopId':shopid
    };
  }
}
