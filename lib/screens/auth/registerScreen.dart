import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IS3"),
        leading: Image.asset(
          "assets/logo.png",
          scale: 8,
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).canvasColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Register',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorsRes.themeTextBlue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Please enter your mobile phone number',
              style: TextStyle(color: ColorsRes.textBlack, fontSize: 15),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD1D1D1)),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const CountryCodePicker(
                    initialSelection: 'IN',
                    favorite: ['+91', 'IN'],
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            isloading
                ? const Card(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isloading = true;
                        });
                        final phoneNumber =
                            "+91 " + _phoneController.text.trim();
                        print("phone $phoneNumber");

                        await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: phoneNumber,
                            verificationCompleted:
                                (PhoneAuthCredential credential) async {
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential)
                                  .then((value) async {
                                if (value.user != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Phone number automatically verified and user signed in: ${value.user?.uid}')));
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    userInfoScreen,
                                    (route) => false,
                                  );
                                }
                              });
                            },
                            verificationFailed: (FirebaseAuthException e) {
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  isloading = false;
                                });
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Phone number verification failed. Message: Try again later')));
                              print(e.message);
                            },
                            codeSent: ((verificationId, forceResendingToken) {
                              setState(() {
                                isloading = false;
                              });
                              Navigator.pushNamed(context, otpScreen,
                                  arguments: verificationId);
                            }),
                            codeAutoRetrievalTimeout: (verificationId) {
                              log("Retrival time out");
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsRes.themeBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Send OTP',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
            const SizedBox(height: 10),
            const Text(
              'By clicking continue, you agree to our Terms of Service and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFF1D1D1D)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
