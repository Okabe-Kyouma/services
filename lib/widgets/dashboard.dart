import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/first_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome + username'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirstScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Logout'))
        ],
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        automaticallyImplyLeading: false,
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          await showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Do you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          );
        },
        child: const Center(
          child: Text('hi'),
        ),
      ),
    );
  }
}
