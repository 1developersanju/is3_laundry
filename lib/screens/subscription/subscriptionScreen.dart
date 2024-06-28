import 'dart:async';
import 'package:flutter/material.dart';
import 'package:laundry/helpers/colorRes.dart'; // Assuming this is for custom colors
import 'package:laundry/helpers/utlis/routeGenerator.dart'; // Assuming this is for navigation routes
import 'package:laundry/helpers/widgets/customAppbar.dart'; // Assuming this is a custom app bar widget

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
      body: Column(
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
                        width: _containerSize * _sizeFactor, // Adjust width based on _containerSize and _sizeFactor
                        height: _containerSize * _sizeFactor, // Adjust height based on _containerSize and _sizeFactor
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSubscriptionOption("1 month", "₹ 500"),
                      const SizedBox(width: 10),
                      _buildSubscriptionOption("3 month", "₹ 1000"),
                      const SizedBox(width: 10),
                      _buildSubscriptionOption("6 month", "₹ 1500"),
                    ],
                  ),
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
                // Implement your booking logic here
                  Navigator.pushNamed(context, bookingSuccessScreen, arguments: ['Subscribtion Successful!!!','assets/booking_successful.json']);
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
    );
  }

  Widget _buildSubscriptionOption(String duration, String price) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: ColorsRes.themeBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            duration,
            style: TextStyle(color: ColorsRes.colorWhite),
          ),
          Text(
            price,
            style: TextStyle(color: ColorsRes.colorWhite),
          ),
        ],
      ),
    );
  }
}
