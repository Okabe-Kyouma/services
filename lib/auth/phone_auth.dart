import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});
  @override
  State<PhoneAuth> createState() {
    return _PhoneAuthState();
  }
}

class _PhoneAuthState extends State<PhoneAuth> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('ho'),
          ],
        ),
      ),
    );
  }
}
