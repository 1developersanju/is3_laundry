import 'package:flutter/material.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/widgets/customAppbar.dart';
import 'package:laundry/providers/bottomBarProvider.dart';
import 'package:laundry/providers/userDataProvider.dart';
import 'package:laundry/screens/home/homeScreen.dart';
import 'package:laundry/screens/orders.dart/order_list.dart';
import 'package:laundry/screens/profile/profileScreen.dart';
import 'package:laundry/screens/shops/AddShopScreen.dart';
import 'package:laundry/screens/subscription/subscriptionScreen.dart';
import 'package:provider/provider.dart';

class BottomBarScreen extends StatelessWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomBarProvider = Provider.of<BottomBarProvider>(context);
    final phoneNumber = Provider.of<UserDataProvider>(context).phoneNumber;

    // Determine if the "Add" icon and "Shop" item should be included
    final bool showAddIcon = phoneNumber == "+917339629247";

    final List<Widget> _widgetOptions = [
      const HomeScreen(),
      const OrdersPage(),
      const Subscriptionscreen(),
      const ProfileScreen(),
      if (showAddIcon) AddShopPage(),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(bottomBarProvider.selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: ColorsRes.themeBlue,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: ColorsRes.themeBlue,
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.verified,
              color: ColorsRes.themeBlue,
            ),
            label: "Subscription",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: ColorsRes.themeBlue,
              radius: 18,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).canvasColor,
                child: Icon(
                  Icons.person,
                  color: ColorsRes.themeBlue,
                ),
              ),
            ),
            label: "Profile",
          ),
          if (showAddIcon)
            BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundColor: ColorsRes.themeBlue,
                radius: 18,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).canvasColor,
                  child: Icon(
                    Icons.add,
                    color: ColorsRes.themeBlue,
                  ),
                ),
              ),
              label: "Shop",
            ),
        ],
        currentIndex: bottomBarProvider.selectedIndex,
        selectedItemColor: ColorsRes.themeBlue,
        onTap: bottomBarProvider.setIndex,
      ),
    );
  }
}
