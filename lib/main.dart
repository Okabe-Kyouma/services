import 'package:flutter/material.dart';
import 'package:services/auth/phone_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PhoneAuth(),
    );
  }
}
