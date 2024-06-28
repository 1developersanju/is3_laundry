import 'package:flutter/material.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/screens/home/homeScreen.dart';
import 'package:laundry/screens/orders.dart/order_list.dart';
import 'package:laundry/screens/profile/profileScreen.dart';
import 'package:laundry/screens/shops/AddShopScreen.dart';
import 'package:laundry/screens/subscription/subscriptionScreen.dart';


class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() =>
      _BottomBarScreenState();
}

class _BottomBarScreenState
    extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  static  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const OrdersPage(),
    const Subscriptionscreen(),
    const ProfileScreen(),
   AddShopPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: ColorsRes.themeBlue,),
            label: "Home",


          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined,color: ColorsRes.themeBlue,),
            label:"Cart",

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified,color: ColorsRes.themeBlue,),
            label: "Subscribtion"

          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(backgroundColor: ColorsRes.themeBlue,radius: 18,child: CircleAvatar(radius: 16,backgroundColor: Theme.of(context).canvasColor, child: Icon(Icons.person,color: ColorsRes.themeBlue,))),
            label: "Profile"
            

          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(backgroundColor: ColorsRes.themeBlue,radius: 18,child: CircleAvatar(radius: 16,backgroundColor: Theme.of(context).canvasColor, child: Icon(Icons.add,color: ColorsRes.themeBlue,))),
            label: "Shop"
            

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorsRes.themeBlue,
        onTap: _onItemTapped,
      ),
    );
  }
}
