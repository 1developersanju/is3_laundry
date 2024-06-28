import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:laundry/helpers/widgets/customAppbar.dart';
import 'package:laundry/providers/userDataProvider.dart';
import 'package:provider/provider.dart';
import 'package:laundry/providers/orderProvider.dart';
import 'package:laundry/model/orderModel.dart';

class ShopDetailScreen extends StatefulWidget {
  final String title;
  final List services;
  final int price;

  ShopDetailScreen(
      {Key? key,
      required this.title,
      required this.services,
      required this.price})
      : super(key: key);

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  bool _isDarkMode = false;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    // Fetch the current user's phone number and address from the profile and set the controllers
    var userProvider = Provider.of<UserDataProvider>(context, listen: false);
    _phoneController.text = userProvider.currentUser!.phoneNumber.toString();
    _addressController.text = userProvider.addressLine1.toString();
  }

  @override
  Widget build(BuildContext context) {
    List servicesList = widget.services;

    return Scaffold(
      appBar: CustomAppBar(
        isDarkMode: _isDarkMode,
        needActions: true,
        implyBackButton: true,
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
      backgroundColor: ColorsRes.canvasColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: ColorsRes.textBlack,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Services:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: ColorsRes.textBlack,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  children: List.generate(
                    servicesList.length,
                    (index) => ChoiceChip(
                      checkmarkColor: ColorsRes.colorWhite,
                      selected: _selectedIndex ==
                          index, // Check if this chip is selected
                      onSelected: (selected) {
                        setState(() {
                          _selectedIndex =
                              selected ? index : -1; // Update selected index
                        });
                      },
                      label: Text(
                        servicesList[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedIndex == index
                              ? ColorsRes.colorWhite
                              : Colors
                                  .black, // Change text color based on selection
                        ),
                      ),
                      selectedColor: ColorsRes
                          .themeBlue, // Change chip color when selected
                      // backgroundColor: Colors.grey.shade300, // Default chip color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Approximate kg:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: ColorsRes.textBlack,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD1D1D1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Phone Number:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: ColorsRes.textBlack,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD1D1D1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const CountryCodePicker(
                      initialSelection: 'IN',
                      favorite: ['+91', 'IN'],
                      showCountryOnly: false,
                      alignLeft: false,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Address:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: ColorsRes.textBlack,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD1D1D1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  maxLines: 5,
                  controller: _addressController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedIndex == -1 ||
                        _weightController.text.isEmpty ||
                        _phoneController.text.isEmpty ||
                        _addressController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please fill all fields and select a service.')),
                      );
                      return;
                    }

                    var userProvider =
                        Provider.of<UserDataProvider>(context, listen: false);
                    var currentUser = userProvider.currentUser;

                    var order = Orders(
                      id: currentUser!.uid,
                      serviceType: servicesList[_selectedIndex],
                      weight: double.parse(_weightController.text),
                      phoneNumber: _phoneController.text,
                      location: _addressController.text,
                      dateTime: DateTime.now(),
                      status: "",
                      price:
                          widget.price * double.parse(_weightController.text),
                    );

                    var orderProvider =
                        Provider.of<OrderProvider>(context, listen: false);
                    await orderProvider.createOrder(order);

                    Navigator.pushNamed(context, bookingSuccessScreen,
                        arguments: [
                          'Booked successfully. \nOur team member will contact you shortly.\nThank you!!!',
                          'assets/booking_successful.json'
                        ]);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsRes.themeBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
