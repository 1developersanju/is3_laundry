import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry/model/shopModel.dart';

class ShopProvider extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseStorage _storage = FirebaseStorage.instance;

  List<Shop> _shops = [];

  List<Shop> get shops => _shops;
  Future<String> uploadImage(File image) async {
    try {
      String fileName = 'shops/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference reference = _storage.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  // Fetch shops from Firestore
  Future<void> fetchShops() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('shops').get();
      _shops = snapshot.docs.map((doc) {
        return Shop(
          id: doc.id,
          image: doc['image'],
          title: doc['title'],
          price: doc['price'],
          location: doc['location'],
          services: List<String>.from(doc['services']),
          isBookmarked: doc['isBookmarked'] ?? false,
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching shops: $e');
    }
  }

  // Add a shop to Firestore
  Future<void> addShop(Shop shop) async {
    try {
      DocumentReference ref = await _firestore.collection('shops').add({
        'image': shop.image,
        'title': shop.title,
        'price': shop.price,
        'location': shop.location,
        'services': shop.services,
        'isBookmarked': shop.isBookmarked,
      });
      shop = shop.copyWith(id: ref.id);
      _shops.add(shop);
      notifyListeners();
    } catch (e) {
      print('Error adding shop: $e');
    }
  }

  // Update a shop in Firestore
  Future<void> updateShop(Shop shop) async {
    try {
      await _firestore.collection('shops').doc(shop.id).update({
        'image': shop.image,
        'title': shop.title,
        'price': shop.price,
        'location': shop.location,
        'services': shop.services,
        'isBookmarked': shop.isBookmarked,
      });
      int index = _shops.indexWhere((s) => s.id == shop.id);
      if (index != -1) {
        _shops[index] = shop;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating shop: $e');
    }
  }

  // Delete a shop from Firestore
  Future<void> deleteShop(String id) async {
    try {
      await _firestore.collection('shops').doc(id).delete();
      _shops.removeWhere((shop) => shop.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting shop: $e');
    }
  }
}
