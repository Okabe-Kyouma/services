import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.username,
    required this.profilePhotoLink,
    required this.phoneNumber,
    required this.fullname,
    required this.service,
    required this.exp,
  });

  final String username;
  final String profilePhotoLink;
  final String phoneNumber;
  final String fullname;
  final String service;
  final String exp;

  @override
  Widget build(BuildContext context) {
    print('The image that imgonna display: ${profilePhotoLink.substring(8)}');
    String phn = phoneNumber.substring(0, 4);
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    profilePhotoLink,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/logos/services_logo.png',
                        width: 80,
                        height: 80,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullname,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Cell +91${phn}XXXXXX",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    // Text(
                    //   username,
                    //   style: const TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 1,
            ),
            const SizedBox(height: 8),
            // Text(
            //   'Service: $service',
            //   style: const TextStyle(
            //     fontSize: 16,
            //   ),
            // ),
            const SizedBox(height: 4),
            Text(
              'Experience: $exp',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            ListTile(
              title: Text('Message This person'),
              leading: Icon(Icons.message),
            )
            // Text(
            //   'Address: $address',
            //   style: const TextStyle(
            //     fontSize: 16,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
