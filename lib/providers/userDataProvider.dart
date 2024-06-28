import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class UserDataProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // User data fields
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;
  String? _dob;
  String? _email;
  String? _gender;
  String? _profileImageUrl;
  String? _addressLine1;
  String? _addressLine2;

  // Getters for user data
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get phoneNumber => _phoneNumber;
  String? get dob => _dob;
  String? get email => _email;
  String? get gender => _gender;
  String? get profileImageUrl => _profileImageUrl;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;

  // Getter for current authenticated user
  User? get currentUser => _auth.currentUser;

  Future<bool> checkUserExists(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      return userDoc.exists;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  Future<void> saveUserData({
    required String uid,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String dob,
    required String email,
    required String gender,
    File? profileImage,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      bool userExists = await checkUserExists(uid);

      // Prepare user data to save
      Map<String, dynamic> userData = {
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'dob': dob,
        'email': email,
        'gender': gender,
      };

      // Upload profile image if provided
      if (profileImage != null) {
        String imageUrl = await _uploadProfileImage(uid, profileImage);
        userData['profileImageUrl'] = imageUrl;
      }

      // Save or update user data
      if (userExists) {
        await _firestore.collection('users').doc(uid).update(userData);
      } else {
        await _firestore.collection('users').doc(uid).set(userData);
      }

      // Update local fields
      _firstName = firstName;
      _lastName = lastName;
      _phoneNumber = phoneNumber;
      _dob = dob;
      _email = email;
      _gender = gender;
      _profileImageUrl = userData['profileImageUrl'];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e; // Handle error as needed
    }
  }

  Future<String> _uploadProfileImage(String uid, File imageFile) async {
    try {
      Reference storageRef = _storage.ref().child('users/$uid/profile.jpg');
      await storageRef.putFile(imageFile);
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  Future<void> updateUserData({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? dob,
    String? email,
    String? gender,
    String? addressLine1,
    String? addressLine2,
    File? profileImage,
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentReference userRef =
            _firestore.collection('users').doc(currentUser.uid);
        Map<String, dynamic> updatedData = {};

        // Add fields to update based on provided parameters
        if (firstName != null) updatedData['firstName'] = firstName;
        if (lastName != null) updatedData['lastName'] = lastName;
        if (phoneNumber != null) updatedData['phoneNumber'] = phoneNumber;
        if (dob != null) updatedData['dob'] = dob;
        if (email != null) updatedData['email'] = email;
        if (gender != null) updatedData['gender'] = gender;

        // Update profile image if provided
        if (profileImage != null) {
          String imageUrl =
              await _uploadProfileImage(currentUser.uid, profileImage);
          updatedData['profileImageUrl'] = imageUrl;
        }

        // Perform the update in Firestore
        await userRef.update(updatedData);

        // Update local data
        _firstName = firstName ?? _firstName;
        _lastName = lastName ?? _lastName;
        _phoneNumber = phoneNumber ?? _phoneNumber;
        _dob = dob ?? _dob;
        _email = email ?? _email;
        _gender = gender ?? _gender;
        _profileImageUrl = updatedData['profileImageUrl'] ?? _profileImageUrl;

        // Notify listeners about the changes
        notifyListeners();
      }
    } catch (e) {
      print('Error updating user data: $e');
      throw e;
    }
  }

    Future<void> saveOrUpdateAddress({
    required String addressLine1,
    required String addressLine2,
  }) async {
    try {
      // Check if the user has an existing address document
      final addressRef = _firestore.collection('users').doc(currentUser!.uid);

      // Use a transaction for atomicity
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(addressRef);

        if (snapshot.exists) {
          // Update existing address
          transaction.update(addressRef, {
            'addressLine1': addressLine1,
            'addressLine2': addressLine2,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          
          // Create new address document
          transaction.set(addressRef, {
            'addressLine1': addressLine1,
            'addressLine2': addressLine2,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      print('Error saving or updating address: $e');
      throw e;
    }
  }


  // Method to fetch user data from Firestore
  Future<void> fetchUserData(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        _firstName = data['firstName'];
        _lastName = data['lastName'];
        _phoneNumber = data['phoneNumber'];
        _dob = data['dob'];
        _email = data['email'];
        _gender = data['gender'];
        _profileImageUrl = data['profileImageUrl'];
        _addressLine1 = data['addressLine1'];
        _addressLine2= data['addressLine2'];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e; // Handle error as needed
    }
  }
}
