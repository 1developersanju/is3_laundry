import 'package:flutter/material.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:lottie/lottie.dart';

import '../../helpers/widgets/customAppbar.dart';

class BookingSuccessPage extends StatefulWidget {
  String image;
  String text;
   BookingSuccessPage({super.key,required this.image,required this.text});

  @override
  State<BookingSuccessPage> createState() => _BookingSuccessPageState();
}

class _BookingSuccessPageState extends State<BookingSuccessPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
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
      body: Container(
        color: ColorsRes.canvasColor,
        margin: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(widget.image),
            SizedBox(height: 10),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: ColorsRes.textBlack,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  bottomBarScreen,
                  (route) => false,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Back to",style: TextStyle(fontSize: 18),),
                  SizedBox(width: 4),
                  Text(
                    "Home",
                    style: TextStyle(color: ColorsRes.themeTextBlue,fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
