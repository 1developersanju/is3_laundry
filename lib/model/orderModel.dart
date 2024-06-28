import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  final String id;
  final String serviceType;
  final String location;
  final String status;
  final double price;
  final DateTime dateTime;
  final double weight; // Assuming you've already added this
  final String phoneNumber; // New field for phone number

  Orders({
    required this.id,
    required this.serviceType,
    required this.location,
    required this.status,
    required this.price,
    required this.dateTime,
    required this.weight,
    required this.phoneNumber, // Include phone number in the constructor
  });

  factory Orders.fromFirestore(Map<String, dynamic> data, String id) {
    return Orders(
      id: id,
      serviceType: data['serviceType'],
      location: data['location'],
      status: data['status'],
      price: data['price'].toDouble(),
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      weight: data['weight'].toDouble(),
      phoneNumber: data['phoneNumber'], // Retrieve phone number from Firestore
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceType': serviceType,
      'location': location,
      'status': status,
      'price': price,
      'dateTime': Timestamp.fromDate(dateTime),
      'weight': weight,
      'phoneNumber': phoneNumber, // Include phone number in the map
    };
  }
}
