import 'package:flutter/material.dart';

class CategoryClass extends StatelessWidget {
  CategoryClass({super.key, required this.text, required this.imageLink});

  String text;
  String imageLink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
