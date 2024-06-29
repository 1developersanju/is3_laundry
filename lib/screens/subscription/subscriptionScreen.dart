import 'dart:async';
import 'package:flutter/material.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/widgets/customAppbar.dart';
import 'package:laundry/providers/subscribtionPlanProvider.dart';
import 'package:laundry/providers/userDataProvider.dart';

class Subscriptionscreen extends StatefulWidget {
  const Subscriptionscreen({Key? key}) : super(key: key);

  @override
  _SubscriptionscreenState createState() => _SubscriptionscreenState();
}

class _SubscriptionscreenState extends State<Subscriptionscreen> {
  bool _isDarkMode = false;
  double _offsetY = 0.0;
  double _sizeFactor = 1.0;
  double _containerSize = 200.0; // Initial size of the AnimatedContainer
  Map<String, dynamic>? _selectedPlan;
  String? _currentSubscriptionPlan;

bool isSelected =false;
  @override
  void initState() {
    super.initState();
    // Start a timer to update the offset and size periodically
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _offsetY = _offsetY == 0.0 ? 10.0 : 0.0; // Toggle between 0 and 10
        _sizeFactor = _sizeFactor == 1.0 ? 1.2 : 1.0; // Toggle between 1.0 and 1.2
        _containerSize = _containerSize == 200.0 ? 250.0 : 200.0; // Toggle between 200 and 250
      });
    });

    // Fetch initial data from providers
    Provider.of<UserDataProvider>(context, listen: false).fetchSubscriptionPlanFromFirestore();
    Provider.of<SubscriptionPlanProvider>(context, listen: false).fetchSubscriptionPlansFromFirestore();

    // Fetch current subscription plan
    _currentSubscriptionPlan = Provider.of<UserDataProvider>(context, listen: false).getCurrentSubscriptionPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Monthly Subscription",
        isDarkMode: _isDarkMode,
        needActions: true,
        implyBackButton: false,
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;

          });
        },
      ),
      backgroundColor: ColorsRes.canvasColor,
      body: Consumer2<UserDataProvider, SubscriptionPlanProvider>(
        builder: (context, userDataProvider, subscriptionProvider, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          transform: Matrix4.translationValues(0.0, _offsetY, 0.0),
                          width: _containerSize * _sizeFactor,
                          height: _containerSize * _sizeFactor,
                          child: Image.asset('assets/IS3.png'),
                        ),
                      ),
                    ),
                    Card(
                      color: ColorsRes.themeBlue,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                        child: Text(
                          "Our subscription model allows you to use the IS3 bag for storing clothes to be washed, with the service duration based on your chosen plan",
                          style: TextStyle(
                            fontSize: 22.0,
                            color: ColorsRes.colorWhite,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSubscriptionOptions(subscriptionProvider),
                    const SizedBox(height: 10),
                    
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedPlan == null) {
                    // Handle case where no plan is selected
                    return;
                  }

                  String selectedPlanDuration = _selectedPlan!['duration'];
                  double selectedPlanCost = _selectedPlan!['cost'];
                  bool isNextPlanVerified = false;

                  await userDataProvider.setOrUpdateSubscriptionPlan(
                    duration: selectedPlanDuration,
                    cost: selectedPlanCost,
                    status: isNextPlanVerified,
                  );

                  Navigator.pushNamed(context, bookingSuccessScreen, arguments: ['Subscription Successful!!!', 'assets/booking_successful.json']);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsRes.themeBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started with',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      'IS3 subscription',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionOptions(SubscriptionPlanProvider subscriptionProvider) {
    List<Map<String, dynamic>> plans = subscriptionProvider.subscriptionPlans;

    if (plans.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      height: 120.0, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: plans.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> plan = plans[index];
          String duration = plan['duration'];
          double cost = plan['cost'];

           isSelected = _selectedPlan == plan;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPlan = plan;

              });
            },
            child: Container(
              width: 120, // Fixed width for circle
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected || _currentSubscriptionPlan == duration? ColorsRes.themeBlue : ColorsRes.lightBlue,
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    duration,
                    style: TextStyle(color:isSelected || _currentSubscriptionPlan == duration? ColorsRes.colorWhite:ColorsRes.textBlack),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹ $cost',
                    style: TextStyle(color:isSelected|| _currentSubscriptionPlan == duration ? ColorsRes.colorWhite:ColorsRes.textBlack),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


