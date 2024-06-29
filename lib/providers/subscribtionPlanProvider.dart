import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionPlan {
  final String id;
  final String duration;
  final double cost;
  final bool verified;
  final DateTime subscribedOn;

  SubscriptionPlan({
    required this.id,
    required this.duration,
    required this.cost,
    required this.verified,
    required this.subscribedOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'duration': duration,
      'cost': cost,
      'verified': verified,
      'subscribedOn': subscribedOn,
    };
  }

  factory SubscriptionPlan.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return SubscriptionPlan(
      id: doc.id,
      duration: data['duration'] ?? '',
      cost: (data['cost'] ?? 0.0).toDouble(),
      verified: data['verified'] ?? false,
      subscribedOn: (data['subscribedOn'] as Timestamp).toDate(),
    );
  }
}

class SubscriptionPlanProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference plansCollection = FirebaseFirestore.instance.collection('subscription_plans');
  List<Map<String, dynamic>> subscriptionPlans = [];

  List<SubscriptionPlan> _plans = [];

  List<SubscriptionPlan> get plans => _plans;

  Future<void> fetchPlans() async {
    try {
      QuerySnapshot snapshot = await plansCollection.get();
      _plans = snapshot.docs.map((doc) => SubscriptionPlan.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching plans: $e');
    }
  }

  Future<void> addPlan({
    required String duration,
    required double cost,
    required bool verified,
    required DateTime subscribedOn,
  }) async {
    try {
      await plansCollection.add({
        'duration': duration,
        'cost': cost,
        'verified': verified,
        'subscribedOn': subscribedOn,
      });
      await fetchPlans(); // Refresh the local list of plans
    } catch (e) {
      print('Error adding plan: $e');
    }
  }

  Future<void> updatePlan({
    required String planId,
    required String duration,
    required double cost,
    required bool verified,
  }) async {
    try {
      await plansCollection.doc(planId).update({
        'duration': duration,
        'cost': cost,
        'verified': verified,
      });
      await fetchPlans(); // Refresh the local list of plans
    } catch (e) {
      print('Error updating plan: $e');
    }
  }

  Future<void> deletePlan(String planId) async {
    try {
      await plansCollection.doc(planId).delete();
      await fetchPlans(); // Refresh the local list of plans
    } catch (e) {
      print('Error deleting plan: $e');
    }
  }
  Future<void> fetchSubscriptionPlansFromFirestore() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('subscription_plans').get();
      
      // Convert QuerySnapshot to List<Map<String, dynamic>>
      subscriptionPlans = snapshot.docs.map((doc) => doc.data()).toList();
      
      // Notify listeners or update state if using ChangeNotifier
      notifyListeners();
    } catch (error) {
      print("Error fetching subscription plans: $error");
    }
  }

  // Get plan duration by index
  String getPlanDuration(int index) {
    if (index >= 0 && index < subscriptionPlans.length) {
      return subscriptionPlans[index]['duration'];
    }
    return '';
  }

  // Get plan price by index
  String getPlanPrice(int index) {
    if (index >= 0 && index < subscriptionPlans.length) {
      return subscriptionPlans[index]['price'];
    }
    return '';
  }

  // Get plan cost by index
  int getPlanCost(int index) {
    if (index >= 0 && index < subscriptionPlans.length) {
      return subscriptionPlans[index]['cost'];
    }
    return 0;
  }

  // Return number of plans available
  int get planCount => subscriptionPlans.length;
}

