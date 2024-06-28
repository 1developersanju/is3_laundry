import 'package:flutter/material.dart';
import 'package:laundry/helpers/colorRes.dart'; // Assuming this file contains custom colors

class PromisesWidget extends StatelessWidget {
  const PromisesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsRes.lightBlue,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Our Promises",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: ColorsRes.textBlack,
            ),
          ),
          SizedBox(height: 12.0),
          _buildPromiseRow("assets/fast_delivery.png", "Fast Delivery"),
          _buildPromiseRow("assets/reduce_workload.png", "Reduce Your Workload"),
          _buildPromiseRow("assets/affordable.png", "Affordable Price"),
          _buildPromiseRow("assets/clean_and_fresh.png", "Clean and Fresh Clothes"),
        ],
      ),
    );
  }

  Widget _buildPromiseRow(String image, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(
            image,
            height: 32.0, // Adjust image height as needed
          ),
          SizedBox(width: 12.0),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.0,
              color: ColorsRes.textBlack,
            ),
          ),
        ],
      ),
    );
  }
}
