import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:services/api/dio_user_list.dart';
import 'package:services/widgets/providerModels/location_model.dart';
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
  bool isLoading = true;
  Position? position;
  double? latitude;
  double? longitude;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

     position = Provider.of<LocationModel>(context).currentPosition;

     populatelist();
    
  }

  @override
  void initState() {
    super.initState();
    print('calling this');
  }

  

  void populatelist() async {
    setState(() {
      isLoading = true;
    });
     
   
    print('position:........................$position');
    

    latitude = position!.latitude;
    longitude = position!.longitude;

    var response = await getUserList(widget.text, latitude!, longitude!);

    if (response is List) {
      setState(() {
        userList = response;
        isLoading = false;
        print('userlist: $userList');
      });
    } else {
      setState(() {
        isLoading = false;
      });
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
            child: isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator
                : userList.isEmpty
                    ? const Center(child: Text('No service Provider Found'))
                    : ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return UserInfo(
                              username: userList[index]['username'],
                              address: userList[index]['homeLocation'],
                              exp: '2-4 years',
                              fullname: userList[index]['fullname'],
                              phoneNumber: userList[index]['phoneNumber'],
                              profilePhotoLink: userList[index]
                                  ['profilePictureUrl'],
                              service: userList[index]['service']);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
