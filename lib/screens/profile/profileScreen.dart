import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/widgets/customAppbar.dart';
import 'package:laundry/providers/userDataProvider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;
  File? _profileImage; // To store the profile image
  String uid = FirebaseAuth.instance.currentUser!.uid;

  late UserDataProvider _userDataProvider; // Instance of UserDataProvider

  // Profile details
  String _name = "";
  String _phoneNumber = "";
  String _dob = "";
  String _gender = "";
  String _email = "";
  String _addressLine1 = "";
  String _addressLine2 = "";

  final TextEditingController _editingController = TextEditingController();
  String? _editingField;

  @override
  void initState() {
    super.initState();
    _userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    _fetchUserData();
  }

Future<void> _fetchUserData() async {
  try {
    await _userDataProvider.fetchUserData(uid);
    setState(() {
      _name = _userDataProvider.firstName ?? "";
      _phoneNumber = _userDataProvider.phoneNumber ?? "";
      _dob = _userDataProvider.dob ?? "";
      _gender = _userDataProvider.gender ?? "";
      _email = _userDataProvider.email ?? "";
      _addressLine1 = _userDataProvider.addressLine1 ?? "";
      _addressLine2 = _userDataProvider.addressLine2 ?? "";
    });
  } catch (e) {
    print('Error fetching user data: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isDarkMode: _isDarkMode,
        title: "Profile",
        centerTitle: true,
        needActions: true,
        implyBackButton: false,
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
      backgroundColor: ColorsRes.canvasColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          color: ColorsRes.canvasColor,
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorsRes.themeBlue,
                      radius: 40,
                      backgroundImage: _userDataProvider.profileImageUrl == null
                          ? null // No background image if profileImageUrl is null
                          : NetworkImage(
                              _userDataProvider.profileImageUrl.toString()),
                      child: _userDataProvider.profileImageUrl == null
                          ? Icon(Icons.person,
                              color: ColorsRes.colorWhite, size: 40)
                          : null, // No child if profileImageUrl is not null
                    ),
                    TextButton(
                      onPressed: _pickImage,
                      child: Text(
                        "Edit profile image",
                        style: TextStyle(color: ColorsRes.blue, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              _buildEditableListTile('Name', _name, (value) {
                _updateUserData(firstName: value);
              }, false, false),
              _buildEditableListTile('Phone Number', _phoneNumber, (value) {
                _updateUserData(phoneNumber: value);
              }, true, false),
              _buildDateOfBirthListTile('Date Of Birth', _dob, (value) {
                _updateUserData(dob: value);
              }),
              _buildGenderListTile(),
              _buildEditableListTile('Email', _email, (value) {
                _updateUserData(email: value);
              }, false, true),
              _buildAddressListTile(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _updateUserData(profileImage: _profileImage);
      });
    }
  }

  Widget _buildEditableListTile(String title, String value,
      ValueChanged<String> onChanged, bool? phoneKey, bool? emailKey) {
    return ListTile(
      leading: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      title: Text(
        value,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {
        _editingController.text = value;
        _editingField = title;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      keyboardType: phoneKey == true
                          ? TextInputType.number
                          : emailKey == true
                              ? TextInputType.emailAddress
                              : TextInputType.text,
                      controller: _editingController,
                      decoration: InputDecoration(labelText: 'Edit $title'),
                      autofocus: true,
                    ),
                    SizedBox(
                      // width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          onChanged(_editingController.text);
                          _updateUserData();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsRes.themeBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Save',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDateOfBirthListTile(
      String title, String value, ValueChanged<String> onChanged) {
    return ListTile(
      leading: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      title: Text(
        value,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () async {
        DateTime initialDate = DateTime.tryParse(_dob) ?? DateTime.now();
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          onChanged(pickedDate.toIso8601String().substring(0, 10));
          _updateUserData(dob: pickedDate.toIso8601String().substring(0, 10));
        }
      },
    );
  }

  Widget _buildGenderListTile() {
    return ListTile(
      leading: const Text(
        'Gender',
        style: TextStyle(fontSize: 18),
      ),
      title: Text(
        _gender,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<String>(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                          _updateUserData(gender: value);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                          _updateUserData(gender: value);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAddressListTile() {
    return ListTile(
      leading: const Text(
        'Address',
        style: TextStyle(fontSize: 18),
      ),
      title: Text(
        _addressLine1,
        style: const TextStyle(fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: TextEditingController(text: _addressLine1),
                      decoration:
                          const InputDecoration(labelText: 'Address Line 1'),
                      autofocus: true,
                      onChanged: (value) {
                        _addressLine1 = value;
                      },
                    ),
                                        SizedBox(
                      // width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _updateUserData(
                              addressLine1: _addressLine1,
);
                          setState(() {});
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsRes.themeBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Save',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _updateUserData({
    String? firstName,
    String? phoneNumber,
    String? dob,
    String? gender,
    String? email,
    String? addressLine1,
    File? profileImage,
  }) {
    _userDataProvider.updateUserData(
      firstName: firstName,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      email: email,
      profileImage: profileImage,
    );
    _userDataProvider.saveOrUpdateAddress(addressLine1: addressLine1.toString());
  }
}
