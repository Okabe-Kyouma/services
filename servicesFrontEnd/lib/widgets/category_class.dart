import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:services/api/dio_user_list.dart';

class CategoryClass extends StatefulWidget {
  const CategoryClass({super.key, required this.text, required this.imageLink});

  final String text;
  final String imageLink;

  @override
  State<CategoryClass> createState() => _CategoryClassState();
}

class _CategoryClassState extends State<CategoryClass> {
  var userList = [];
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    getUserList(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.text),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
      ),
      body: Hero(
        tag: widget.text,
        child: SizedBox(
          width: double.infinity,
          height: 255,
          child: Image.asset(widget.imageLink),
        ),
      ),
    );
  }
}
