import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:laundry/firebase_options.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:laundry/helpers/utlis/authServices.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:laundry/providers/orderProvider.dart';
import 'package:laundry/providers/shopProvider.dart';
import 'package:laundry/providers/userDataProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ChangeNotifierProvider<UserDataProvider>(create: (_) => UserDataProvider()),
    ChangeNotifierProvider(create: (_) => ShopProvider()..fetchShops()),
    ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),


    // Add more providers as needed
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            clipBehavior: Clip.antiAlias,
          ),
          canvasColor: ColorsRes.canvasColor,
          inputDecorationTheme: InputDecorationTheme(
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8.0),
            //   borderSide: const BorderSide(
            //     color: Colors.blue,
            //   ),
            // ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8.0),
            //   borderSide: const BorderSide(
            //     color: Colors.blue,
            //   ),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8.0),
            //   borderSide: const BorderSide(
            //     color: Colors.blue,
            //     width: 2.0,
            //   ),
            // ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
            ),
          ),
          cardTheme: CardTheme(color: ColorsRes.canvasColor)),
      initialRoute: splashScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
