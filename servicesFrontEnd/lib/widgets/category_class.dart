import 'package:flutter/material.dart';

class CategoryClass extends StatelessWidget {
  const CategoryClass({super.key, required this.text, required this.imageLink});

 final String text;
  final String imageLink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
      ),
      body: Hero(
        tag: text,
        child: SizedBox(
          width: double.infinity,
          height: 255,
          child: Image.asset(imageLink),
        ),
      ),
    );
  }
}
