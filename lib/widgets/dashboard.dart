import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome + username'),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        ),
        body: Text('hi'));
  }
}
