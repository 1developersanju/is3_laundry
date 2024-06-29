import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/screens/home/homeScreen.dart';
import 'package:laundry/screens/auth/otpScreen.dart';
import 'package:laundry/screens/auth/registerScreen.dart';
import 'package:laundry/screens/bottomBarScreen.dart';
import 'package:laundry/screens/getStartedScreen.dart';
import 'package:laundry/screens/orders.dart/order_list.dart';
import 'package:laundry/screens/profile/profileScreen.dart';
import 'package:laundry/screens/shops/bookingSuccessPage.dart';
import 'package:laundry/screens/shops/shopDetail.dart';
import 'package:laundry/screens/shops/shopList.dart';
import 'package:laundry/screens/subscription/manageSubscribtion.dart';
import 'package:laundry/screens/subscription/subscriptionScreen.dart';
import 'package:laundry/screens/userInfoScreen.dart';
import 'package:laundry/screens/utils/addressPicker.dart';
import 'package:laundry/screens/utils/contactUs.dart';
import 'package:laundry/splashScreen.dart';

const String splashScreen = 'splashScreen';
const String homeScreen = 'homeScreen';
const String registerScreen = 'registerScreen';
const String otpScreen = 'otpScreen';
const String userInfoScreen = 'userInfoScreen';
const String getStartedScreen = "getStartedScreen";
const String bottomBarScreen = "bottomBarScreen";
const String shopListScreen = "ShopListScreen";
const String shopDetailScreen = "ShopDetailScreen";
const String bookingSuccessScreen = 'BookingSuccessScreen';
const String orderListScreen = 'orderListScreen';
const String subscribtionScreen = 'subscribtionScreen';
const String profileScreen = 'profileScreen';
const String contactUs = 'contactUs';
const String addressPickerScreen = 'addressPickerScreen';
const String manageSubscriptionPlansPage = 'manageSubscriptionPlansPage';
String currentRoute = splashScreen;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentRoute = settings.name ?? "";

    switch (settings.name) {
      case splashScreen:
        return CupertinoPageRoute(
          builder: (_) => SplashScreen(),
        );

      case homeScreen:
        return CupertinoPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case registerScreen:
        return CupertinoPageRoute(
          builder: (_) => LoginScreen(),
        );

      case otpScreen:
        return CupertinoPageRoute(
          builder: (_) => OtpScreen(
            verificationId: settings.arguments.toString(),
          ),
        );

      case userInfoScreen:
        return CupertinoPageRoute(
          builder: (_) => UserInfoScreen(),
        );

      case getStartedScreen:
        return CupertinoPageRoute(builder: (_) => GetStartedScreen());

      case bottomBarScreen:
        return CupertinoPageRoute(builder: (_) => const BottomBarScreen());

      case shopListScreen:
        return CupertinoPageRoute(builder: (_) => ShopListPage());

      case shopDetailScreen:
        List<dynamic> shopDetailArgs = settings.arguments as List<dynamic>;

        return CupertinoPageRoute(
            builder: (_) => ShopDetailScreen(
                  title: shopDetailArgs[0] as String,
                  services: shopDetailArgs[1],
                  price: shopDetailArgs[2],
                  shopName: shopDetailArgs[3],
                  shopId: shopDetailArgs[4],
                ));

      case bookingSuccessScreen:
        List<dynamic> successPageArgs = settings.arguments as List<dynamic>;

        return CupertinoPageRoute(
            builder: (_) => BookingSuccessPage(
                text: successPageArgs[0], image: successPageArgs[1]));

      case orderListScreen:
        return CupertinoPageRoute(builder: (_) => const OrdersPage());

      case subscribtionScreen:
        return CupertinoPageRoute(builder: (_) => const Subscriptionscreen());

      case profileScreen:
        return CupertinoPageRoute(builder: (_) => const ProfileScreen());

      case contactUs:
        return CupertinoPageRoute(builder: (_) => ContactUsPage());

      case manageSubscriptionPlansPage:
        return CupertinoPageRoute(builder: (_) => ManageSubscriptionPlansPage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class ScreenArguments {
  final String title;
  final List services;

  ScreenArguments(this.title, this.services);
}
