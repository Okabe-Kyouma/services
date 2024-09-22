import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:services/addharAuth/number_widget.dart';

final colorScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 125, 94, 158));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDE3CEW3kTZK5LxNN_qjLWCH4rx4A_2ues",
          appId: "1:69047120729:android:9f24bd5bba8f6da2a79248",
          messagingSenderId: "69047120729",
          projectId: "services-e8b07"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.from(colorScheme: colorScheme)
            .copyWith(colorScheme: colorScheme),
        home: const Number());
  }
}
