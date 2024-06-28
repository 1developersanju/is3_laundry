import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundry/providers/userDataProvider.dart';
import 'package:laundry/screens/auth/registerScreen.dart';
import 'package:laundry/screens/bottomBarScreen.dart'; // Assuming BottomBarScreen is your main app screen
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
    

  }

  Future<void> _loadData() async {
    // Fetch user data in the background


    // Check if user data exists in Firestore
    bool userExists = await Provider.of<UserDataProvider>(context, listen: false).checkUserExists(FirebaseAuth.instance.currentUser?.uid ?? '');

    // Navigate to the appropriate screen after a short delay
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => userExists && FirebaseAuth.instance.currentUser != null
              ? BottomBarScreen() // Navigate to main app screen if user exists
              : LoginScreen(),    // Navigate to login screen if user does not exist
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/logo.png'),
      title: const Text(
        "IS3",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      showLoader: false,
      durationInSeconds: 2,
    );
  }
}
