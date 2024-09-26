import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:services/widgets/splash_screen.dart';

final colorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 125, 94, 158));

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.from(colorScheme: colorScheme).copyWith(
            colorScheme: colorScheme,
            textTheme: GoogleFonts.montserratTextTheme()),
        home: const SplashScreen());
  }
}
