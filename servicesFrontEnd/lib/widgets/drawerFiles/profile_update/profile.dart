import 'package:flutter/material.dart';
import 'package:services/api/dio_profile.dart';
import 'package:services/widgets/drawerFiles/profile_update/show_and_update_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
      ),
      body: Container(
        child: FutureBuilder(
          future: getProfileDate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: PopScope(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Server Error!',
                  style: TextStyle(
                      color: Theme.of(context)
                          .primaryTextTheme
                          .displaySmall
                          ?.color),
                ),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              return ShowNUpdate(profileData: data);
            } else {
              return const Text('No data is available');
            }
          },
        ),
      ),
    );
  }
}
