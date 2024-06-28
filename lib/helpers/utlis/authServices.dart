import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:laundry/providers/userDataProvider.dart';


class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserDataProvider _userDataProvider = UserDataProvider();
  bool isLoading = false;

  Future<void> verifyPhoneNumber(BuildContext context, String phoneNumber) async {
    isLoading = true;
    notifyListeners();

    try {
      String formattedPhoneNumber = "+91 " + phoneNumber.trim().replaceAll(' ', '');
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Phone number automatically verified and user signed in: ${value.user!.uid}')),
              );
              await _checkAndNavigate(context, value.user!);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading = false;
          notifyListeners();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Phone number verification failed. Message: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          isLoading = false;
          notifyListeners();

          Navigator.pushNamed(context, otpScreen, arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto retrieval timeout logic if needed
        },
      );
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Error in phone number verification: $e');
    }
  }

  Future<void> signInWithOTP(BuildContext context, String smsCode, String verificationId) async {
    isLoading = true;
    notifyListeners();

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      await _auth.signInWithCredential(credential);
      User? user = _auth.currentUser;
      if (user != null) {
        await _checkAndNavigate(context, user);
      } else {
        isLoading = false;
        notifyListeners();
        print('User is null after signing in with OTP.');
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Error signing in with OTP: $e');
    }
  }

  Future<void> _checkAndNavigate(BuildContext context, User user) async {
    bool userExists = await _userDataProvider.checkUserExists(user.uid);
    if (userExists) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        bottomBarScreen,
        (route) => false,
      );
    } else {
      Navigator.pushNamed(context, userInfoScreen);
    }
    isLoading = false;
    notifyListeners();
  }
}
