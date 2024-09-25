import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:services/auth/addharAuth/enter_aadhar_number.dart';
import 'package:services/auth/login/login.dart';
import 'package:services/first_screen.dart';
import 'package:services/widgets/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool isUserLoggedIn = false;

  void checkIfUserLoggedIn() {
    
    setState(() {
      isUserLoggedIn = !isUserLoggedIn;
    });
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FirstScreen()),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logos/home_logo.png'),
            const SizedBox(height: 20),
            Text(
              'Services',
              style: GoogleFonts.lato(fontSize: 28),
            ),
          ],
        ),
      ),
    );
  }
}
