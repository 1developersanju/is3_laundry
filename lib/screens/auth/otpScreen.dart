// otpScreen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundry/helpers/utlis/routeGenerator.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:laundry/helpers/colorRes.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final SmsRetriever smsRetriever;
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();

    // In case you need an SMS autofill feature
    smsRetriever = SmsRetrieverImpl(
      SmartAuth(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const fillColor = Color.fromRGBO(243, 246, 249, 0);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: ColorsRes.themeBlue,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: ColorsRes.themeBlue),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("IS3"),
        leading: Image.asset(
          "assets/logo.png",
          scale: 8,
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).canvasColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorsRes.themeTextBlue,
              ),
            ),
            const SizedBox(height: 10),
            const Text('Please enter your OTP HERE',
                style: TextStyle(color: Color(0xFF1D1D1D))),
            const SizedBox(height: 20),
            FractionallySizedBox(
              alignment: Alignment.center,
              widthFactor: 1,
              child: isloading
                  ? Card(
                      child: CircularProgressIndicator(),
                    )
                  : Pinput(
                      length: 6,
                      smsRetriever: smsRetriever,
                      controller: pinController,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      validator: (value) {
                        // Add validation logic if required
                        return value;
                      },
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) async {
                        setState(() {
                          isloading = true;
                        });
                        try {
                          final cred = PhoneAuthProvider.credential(
                              smsCode: pin,
                              verificationId: widget.verificationId);
                          await FirebaseAuth.instance
                              .signInWithCredential(cred);
                          Navigator.pushNamed(context, getStartedScreen);
                          setState(() {
                            isloading = false;
                          });
                        } catch (e) {
                          debugPrint('onCompleted: $pin');
                        }
                        setState(() {
                          isloading = false;
                        });
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: ColorsRes.themeBlue,
                          ),
                        ],
                      ),
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ColorsRes.themeBlue),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(color: ColorsRes.themeBlue),
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: Colors.redAccent),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Resend OTP logic
              },
              child: const Text(
                'Didn\'t receive OTP? Resend OTP',
                style: TextStyle(color: Color(0xFF1D1D1D)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final signature = await smartAuth.getAppSignature();
    debugPrint('App Signature: $signature');
    final res = await smartAuth.getSmsCode(
      useUserConsentApi: true,
    );
    if (res.succeed && res.codeFound) {
      return res.code!;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}
