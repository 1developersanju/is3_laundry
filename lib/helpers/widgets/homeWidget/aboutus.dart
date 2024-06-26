import 'package:flutter/material.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/widgets/homeWidget/imageSliders.dart'; // Assuming this is where imgList is imported from

class Aboutus extends StatelessWidget {
  const Aboutus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsRes.lightBlue,
      padding: EdgeInsets.all(16.0), // Add padding for spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Expanded(
            flex: 2, // Take 2/3 of the row's space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About us",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: ColorsRes.textBlack,
                  ),
                ),
                SizedBox(height: 8.0), // Add space between texts
                Text(
                  "IS3 is a laundry service aggregator. We provide access to nearby laundry services.",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: ColorsRes.textBlack,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2, // Take 1/3 of the row's space
            child: Image.network(
              imgList[0], // Assuming imgList is defined and holds URLs of images
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
