import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';

class GetStartedScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
             Text(
              'Welcome!!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: ColorsRes.themeTextBlue,
              ),
            ),
                        const SizedBox(height: 10),
             Text('Laundry experience in easy steps', style: TextStyle(color: ColorsRes.textGrey,fontSize: 16)),

            const SizedBox(height: 10),
            Image.asset("assets/washing_machine.png"),
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, homeScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsRes.themeBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('GET STARTED', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
           

          ],
        ),
      ),
    );
  }
}
