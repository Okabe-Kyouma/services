import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:services/api/dio_logout.dart';
import 'package:services/api/dio_update.dart';
import 'package:services/first_screen.dart';
import 'package:services/widgets/dashboard_helper.dart';
import 'package:services/widgets/providerModels/location_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Position? position;
  String? address;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    position = Provider.of<LocationModel>(context).currentPosition;
    if (position != null) {
      getAddressFromCoordinates(position!.latitude, position!.longitude);
    }
    upLocation(position!);
  }

  void upLocation(Position position) async {
    await updateLocation(position.latitude, position.longitude);
  }

  void getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      address =
          '${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}';
      setState(() {
        address;
      });
    } catch (e) {
      address = 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: TextButton.icon(
          icon: const Icon(
            Icons.location_on,
            color: Colors.white,
          ),
          onPressed: () {},
          label: Text(
            address ?? "Fetching Location..",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(
                      child: PopScope(
                        canPop: false,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                );

                await logout();

                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirstScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ))
        ],
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        automaticallyImplyLeading: false,
      ),
      body: const DashboardHelper(),
    );
  }
}
