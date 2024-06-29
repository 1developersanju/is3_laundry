import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:laundry/model/shopModel.dart';
import 'package:laundry/providers/shopProvider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AddShopPage extends StatefulWidget {
  @override
  _AddShopPageState createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _servicesController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var shopProvider = Provider.of<ShopProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsRes.canvasColor,
        title: Text('Add Shop'),
      ),
backgroundColor: ColorsRes.canvasColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Tap to pick image', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _servicesController,
                decoration: InputDecoration(
                  labelText: 'Services (comma-separated)',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  
                  onPressed: () async {
                    // Validate inputs
                    if (_titleController.text.isEmpty ||
                        _priceController.text.isEmpty ||
                        _locationController.text.isEmpty ||
                        _servicesController.text.isEmpty ||
                        _imageFile == null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Please fill all fields and pick an image.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    // Upload image and get URL
                    String imageUrl = await shopProvider.uploadImage(_imageFile!);

                    // Add shop to Firestore
                    await shopProvider.addShop(
                      Shop(
                        id: '', // Firestore will generate an id
                        image: imageUrl,
                        title: _titleController.text,
                        price: _priceController.text,
                        location: _locationController.text,
                        services: _servicesController.text.split(',').map((e) => e.trim()).toList(),
                        isBookmarked: false,
                      ),
                    );

                    // Clear input fields
                    _titleController.clear();
                    _priceController.clear();
                    _locationController.clear();
                    _servicesController.clear();
                    setState(() {
                      _imageFile = null;
                    });

                    // Show success message or navigate back
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Success'),
                        content: Text('Shop added successfully.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsRes.themeBlue,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Add Shop', style: TextStyle(fontSize: 18,color: ColorsRes.colorWhite)),
                ),
              ),
              SizedBox(height: 15,),
               SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  
                  onPressed: () async {
                    // Validate inputs
                  Navigator.pushNamed(context, manageSubscriptionPlansPage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsRes.themeBlue,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Manage plans', style: TextStyle(fontSize: 18,color: ColorsRes.colorWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
