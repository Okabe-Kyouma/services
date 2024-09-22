import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:services/auth/otp_screen.dart';

class PhoneAuth extends StatelessWidget {
  const PhoneAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final numberController = TextEditingController();

    void checkNumber(String phone) async {
      if (phone.length > 9) {
        final phoneNumber =
            '+91 ${phone.substring(0, 4)} ${phone.substring(4, 7)} ${phone.substring(7)}';

        FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationCompleted: (phoneAuthCredential) {},
            verificationFailed: (error) {
              print(error);
            },
            codeSent: (verificationId, forceResendingToken) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OtpScreen(verificationId: verificationId),
                ),
              );
            },
            codeAutoRetrievalTimeout: (verificationId) {
              print('auto timeout');
            });
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Enter Your Number"),
                ),
                maxLength: 10,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                checkNumber(numberController.text);
              },
              child: const Text('Send Otp'),
            ),
          ],
        ),
      ),
    );
  }
}
