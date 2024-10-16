import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:services/api/dio_user_list.dart';
import 'package:services/widgets/user_info.dart';

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
    print('calling this');
    populatelist();
  }

  void populatelist() async {
    var response = await getUserList(widget.text);

    if (response is List) {
      setState(() {
        userList = response;
        print('userlist: $userList');
      });
    } else {
      print('Error: Unexpected response format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.text),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Hero(
            tag: widget.text,
            child: SizedBox(
              width: double.infinity,
              height: 255,
              child: Image.asset(widget.imageLink),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return UserInfo(
                    username: userList[index]['username'],
                    address: userList[index]['homeLocation'],
                    exp: '2-4 years',
                    fullname: userList[index]['fullname'],
                    phoneNumber: userList[index]['phoneNumber'],
                    profilePhotoLink: userList[index]['profilePictureUrl'],
                    service: userList[index]['service']);
              },
            ),
          )
        ],
      ),
    );
  }
}
