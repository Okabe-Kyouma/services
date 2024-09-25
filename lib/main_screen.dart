import 'package:flutter/material.dart';
import 'package:services/auth/login/login.dart';
import 'package:services/widgets/dashboard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget? currentScreen;

  @override
  void initState() {
    currentScreen = Login(openDashboard: openDashboard);
    super.initState();
  }

  void openDashboard() {
    setState(() {
      currentScreen = Dashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return currentScreen!;
  }
}
