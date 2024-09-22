import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:services/widgets/home_page.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.verificationId});

  final String verificationId;

  @override
  Widget build(BuildContext context) {
    final numberController2 = TextEditingController();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: numberController2,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Enter otp"),
                ),
                maxLength: 10,
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                try {
                  final cred = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: numberController2.text);

                  await FirebaseAuth.instance.signInWithCredential(cred);

                  //move to next page;
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }
                } catch (err) {
                  print(err);
                }
              },
              child: const Text('verify'),
            ),
          ],
        ),
      ),
    );
  }
}
