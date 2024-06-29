import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:laundry/helpers/widgets/customAppbar.dart';
import 'package:laundry/providers/userDataProvider.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';

import '../helpers/utlis/routeGenerator.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedGender; // Make _selectedGender nullable
  File? _profileImage; // To store the profile image

  @override
  Widget build(BuildContext context) {
    bool _isDarkMode = false;

    return Scaffold(
      appBar: CustomAppBar(
        isDarkMode: _isDarkMode,
        title: "Profile",
        centerTitle: false,
        needActions: false,
        implyBackButton: false,
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
      backgroundColor: ColorsRes.canvasColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(Icons.person, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child:
                          _buildTextField(_firstNameController, 'First Name')),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _buildTextField(_lastNameController, 'Last Name')),
                ],
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              _buildDateField(context, _dobController, 'Date of Birth'),
              const SizedBox(height: 10),
              _buildDropdownField('Gender'),
              const SizedBox(height: 10),
              _buildTextField(_emailController, 'Email Id'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String uid = FirebaseAuth.instance.currentUser!.uid;
                    await Provider.of<UserDataProvider>(context, listen: false)
                        .saveUserData(
                      uid: uid,
                      firstName: _firstNameController.text.trim(),
                      lastName: _lastNameController.text.trim(),
                      dob: _dobController.text.trim(),
                      gender: _selectedGender ?? '',
                      email: _emailController.text.trim(),
                      phoneNumber:
                          FirebaseAuth.instance.currentUser!.phoneNumber!,
                      profileImage: _profileImage,
                    );

                    // Navigate to the MapLocationPicker screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MapLocationPicker(
                            hideBackButton: true,
                            hasLocationPermission: true,
                            hideMapTypeButton: true,
                            bottom: false,
                            bottomCardIcon:
                                Icon(Icons.arrow_forward_ios_rounded),
                            apiKey: "AIzaSyDLnlJhrxMtkd6h_BH6xPp3OaxVDU3jO9g",
                            popOnNextButtonTaped: false, // Prevents pop
                            currentLatLng: const LatLng(11.1271, 78.6569),
                            onNext: (GeocodingResult? result) async {
                              if (result != null) {
                                UserDataProvider userDataProvider =
                                    Provider.of<UserDataProvider>(context,
                                        listen: false);

                                print(result.formattedAddress);
                                await userDataProvider.saveOrUpdateAddress(
                                  addressLine1:
                                      result.formattedAddress.toString(),
                                );
                                // Navigate to the getStartedScreen
                                Navigator.pushReplacementNamed(
                                    context, getStartedScreen);
                              }
                            },
                            onSuggestionSelected:
                                (PlacesDetailsResponse? result) {
                              if (result != null) {
                                // Handle suggestions if necessary
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsRes.themeBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Pick Address',
                      style: TextStyle(color: ColorsRes.colorWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildDateField(
      BuildContext context, TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
    );
  }

  Widget _buildDropdownField(String label) {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      onChanged: (String? newValue) {
        setState(() {
          _selectedGender = newValue!;
        });
      },
      items: <String>['Male', 'Female', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
