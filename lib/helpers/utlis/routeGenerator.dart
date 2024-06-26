import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundry/screens/home/homeScreen.dart';
import 'package:laundry/screens/auth/otpScreen.dart';
import 'package:laundry/screens/auth/registerScreen.dart';
import 'package:laundry/screens/bottomBarScreen.dart';
import 'package:laundry/screens/getStartedScreen.dart';
import 'package:laundry/screens/shops/bookingSuccessPage.dart';
import 'package:laundry/screens/shops/shopDetail.dart';
import 'package:laundry/screens/shops/shopList.dart';
import 'package:laundry/screens/userInfoScreen.dart';
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
          builder: (_) => HomeScreen(),
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
        return CupertinoPageRoute(builder: (_) => BottomBarScreen());

      case shopListScreen:
        return CupertinoPageRoute(builder: (_) => ShopListPage());

      case shopDetailScreen:
        List<dynamic> shopDetailArgs = settings.arguments as List<dynamic>;

        return CupertinoPageRoute(
            builder: (_) => ShopDetailScreen(
                  title: shopDetailArgs[0] as String,
                  services: shopDetailArgs[1],
                ));

      case bookingSuccessScreen:
        return CupertinoPageRoute(builder: (_) => Bookingsuccesspage());

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
