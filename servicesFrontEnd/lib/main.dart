import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:services/widgets/providerModels/aadhar_model.dart';
import 'package:services/widgets/providerModels/email_model.dart';
import 'package:services/widgets/providerModels/location_model.dart';
import 'package:services/widgets/splash_screen.dart';

final colorScheme = ColorScheme.fromSeed(
    seedColor:
        // const Color.fromARGB(255, 125, 94, 158),
        // Color.fromARGB(255, 196, 185, 207),
        Colors.deepPurpleAccent);

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmailModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AadharModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:services/widgets/location_model.dart';
// import 'package:services/first_screen.dart'; // Make sure to import your first screen
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter/cupertino.dart';

// final colorScheme = ColorScheme.fromSeed(
//   seedColor: Colors.deepPurpleAccent,
// );

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(ChangeNotifierProvider(
//     create: (context) => LocationModel(),
//     child: const MyApp(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.from(colorScheme: colorScheme).copyWith(
//         colorScheme: colorScheme,
//         textTheme: GoogleFonts.montserratTextTheme(),
//       ),
//       home: FutureBuilder(
//         future: _determinePosition(context), // Call your location function
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(), // Show loading indicator
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 snapshot.error.toString(),
//                 textAlign: TextAlign.center,
//               ), // Handle error state
//             );
//           } else {
//             return const FirstScreen(); // Navigate to your main screen after permissions are handled
//           }
//         },
//       ),
//     );
//   }

//   Future<void> _determinePosition(BuildContext context) async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         _showLocationSettingsDialog(context);
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       _showLocationSettingsDialog(context);
//       return Future.error('Location permissions are permanently denied, we cannot request permissions.');
//     }

//     Position position = await Geolocator.getCurrentPosition();
//     Provider.of<LocationModel>(context, listen: false)
//         .updatePosition(position);
//   }

//   void _showLocationSettingsDialog(BuildContext context) {
//     showCupertinoDialog(
//       context: context,
//       builder: (context) {
//         return CupertinoAlertDialog(
//           title: const Text('Location Access Denied'),
//           content: const Text(
//               'Please provide your location. The app can\'t work without your location!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Geolocator.openLocationSettings();
//               },
//               child: const Text('Open Settings'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Dismiss the dialog
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }



