import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:services/api/dio_setup.dart';
import 'package:services/api/dio_update.dart';
import 'package:services/widgets/dashboard_helper.dart';
import 'package:services/widgets/drawerFiles/mainFiles/current_user_info.dart';
import 'package:services/widgets/drawerFiles/mainFiles/options.dart';
import 'package:services/widgets/providerModels/location_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Position? position;
  String? address;
  String fullname = 'Loading..';
  String email = 'Loading..';
  String profilePictureUrl = 'assets/logos/services_logo.png';

  Future<void> fetchUserDetails() async {
    final dio = await createDioWithCookieManager();
    try {
      final response = await dio.get(
        '$url/send/userdetails',
      );

      if (response.statusCode == 200) {
        print(
            'response status is received: as the data: ${response.data['fullname']} and ${response.data['email']} and ${response.data['profilePictureUrl']}');
        setState(() {
          fullname = response.data['fullname'];
          email = response.data['email'];
          profilePictureUrl = response.data['profilePictureUrl'];
        });
      } else {
        setState(() {
          fullname = 'Server Error';
          email = 'Server Error';
          profilePictureUrl = 'assets/logos/services_logo.png';
        });
      }
    } catch (e) {
      setState(() {
        fullname = 'Server Error';
        email = 'Server Error';
        profilePictureUrl = 'assets/logos/services_logo.png';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
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
      endDrawer: SafeArea(
        child: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CurrentUserInfo(
                  email: email,
                  fullName: fullname,
                  image: profilePictureUrl,
                ),
                const Options(),
              ],
            ),
          ),
        ),
      ),
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
        actions: [],
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        automaticallyImplyLeading: false,
      ),
      body: const DashboardHelper(),
    );
  }
}
