import 'package:flutter/material.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/screens/home/homeScreen.dart';


class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() =>
      _BottomBarScreenState();
}

class _BottomBarScreenState
    extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
   
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorsRes.themeBlue,
        onTap: _onItemTapped,
      ),
    );
  }
}
