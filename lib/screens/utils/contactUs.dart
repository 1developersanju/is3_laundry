import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:laundry/providers/userDataProvider.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _messageController = TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/contactus.jpg', // Replace with your Lottie animation file path

                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            initialValue: userDataProvider.firstName ?? '',

                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue:
                                userDataProvider.phoneNumber ?? '',
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue:
                                userDataProvider.email ?? '',
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            readOnly: false,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              labelText: 'Message',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your message';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Send message logic
                                await sendEmailToContactUs(
                                    _messageController.text);
                              }
                            },
                            child: const Text(
                              'Send Message',
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> sendEmailToContactUs(String message) async {
  final Email email = Email(
    body: "From  $message",
    subject: 'Message from IS3 Contact Us',
    recipients: ['contactus.laundry@gmail.com'],
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
    print('Email sent successfully');
    // Optionally show a success message or navigate to a success page
    // Navigator.of(context).pushReplacementNamed(successRoute);
  } catch (error) {
    print('Error sending email: $error');
    // Handle error (e.g., show error message)
  }
}
