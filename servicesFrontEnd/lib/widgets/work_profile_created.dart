import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/auth/login/login.dart';

class WorkProfileCreated extends StatelessWidget {
  const WorkProfileCreated({super.key, required this.isWorkProfile});

  final bool isWorkProfile;

  @override
  Widget build(BuildContext context) {
    if (isWorkProfile) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text('Work Profile Created'),
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Image.asset('assets/logos/tick.png'),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'We have Created Your work Profile',
                style: TextStyle(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'In the meantime you can Login and look for services that you need',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
            ],
          )),
        ),
      );
    } else {
      return const Login();
    }
  }
}
