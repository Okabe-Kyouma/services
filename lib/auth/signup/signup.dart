import 'package:flutter/material.dart';
import 'package:services/widgets/dashboard.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const Text('//work to do//'),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Dashboard(),
                  ), (route) {
                return route.settings.name == '/firstScreen';
              });
            },
            child: const Text('Submit'),
          ),
        ],
      )),
    );
  }
}
