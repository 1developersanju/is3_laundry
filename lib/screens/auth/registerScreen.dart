import 'dart:async';

import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:laundry/helpers/utlis/authServices.dart';
import 'package:provider/provider.dart';
import 'package:laundry/helpers/colorRes.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_formatPhoneNumber);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_formatPhoneNumber);
    _phoneController.dispose();
    super.dispose();
  }

  void _formatPhoneNumber() {
    String text = _phoneController.text.replaceAll(' ', '');
    if (text.length > 10) {
      text = text.substring(0, 10);
    }
    if (text.length > 5) {
      text = text.substring(0, 5) + ' ' + text.substring(5);
    }

    // This prevents the controller from reformatting the text multiple times
    _phoneController.value = _phoneController.value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

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
      body: Container(
        color: ColorsRes.canvasColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return Column(
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
                              border: InputBorder.none,
                              hintText: "12345 67890",
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              String phoneNumber = _phoneController.text
                                  .trim()
                                  .replaceAll(' ', '');

                              // Correctly accessing AuthProvider through Provider.of or Consumer
                              await Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .verifyPhoneNumber(context, phoneNumber);
                              Timer(Duration(seconds: 5), () async {
                                setState(() {
                                  isLoading = false;
                                });
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
              );
            },
          ),
        ),
      ),
    );
  }
}
