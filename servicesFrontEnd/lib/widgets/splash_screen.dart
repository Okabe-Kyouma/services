import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:services/first_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restart_app/restart_app.dart';
import 'package:services/widgets/dashboard.dart';
import 'package:services/widgets/providerModels/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool showProg = true;

  void checkIfUserLoggedIn() {
    setState(() {
      isUserLoggedIn = !isUserLoggedIn;
    });
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _determinePosition().then((value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

      setState(() {
        showProg = false;
      });

      Future.delayed(const Duration(seconds: 1), () {
        Widget currentWidget = const FirstScreen();
        

        final String? action = prefs.getString('session');

        print('action: $action');

        if (action != null) {
          currentWidget = const Dashboard();
        }

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => currentWidget,
              settings: const RouteSettings(name: "/firstScreen"),
            ),
          );
        }
      });
    }).catchError((e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Location Access Denied'),
              content: const Text(
                  'Please provide your location , the app cant work without your location!'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Geolocator.openLocationSettings();

                    setState(() {
                      showProg = true;
                    });

                    // await Future.delayed(
                    //   const Duration(seconds: 2),
                    // );

                    await _determinePosition().then((value) {
                      setState(() {
                        showProg = false;
                      });
                      Restart.restartApp();
                    }).catchError((e) {
                      SystemNavigator.pop();
                    });
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            );
          },
        );
      }

      return;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      Provider.of<LocationModel>(context, listen: false)
          .updatePosition(position);
    }
    return position;
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
      body: Stack(
        children: [
          Opacity(
            opacity: showProg ? 0.2 : 1,
            child: Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.background,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 300,
                      width: 300,
                      child: Image.asset('assets/logos/services_logo.png')),
                ],
              ),
            ),
          ),
          if (showProg)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
