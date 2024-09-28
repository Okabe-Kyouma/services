import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:services/widgets/dashboard.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final ImagePicker picker = ImagePicker();

  XFile? pickedImage;

  void pickImage() async {
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            border: const Border(top: BorderSide(color: Colors.black))),
        child: Center(
            child: Form(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: const Text(
                  'Please Fill up your details',
                  style: TextStyle(fontSize: 28),
                ),
              ),
              InkWell(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: pickedImage == null
                      ? Container(
                          margin: const EdgeInsets.only(top: 70),
                          child: const Text(
                            'Upload Image',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : FutureBuilder(
                          future:
                              pickedImage!.readAsBytes(), // Read image as bytes
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If the future is complete, display the image
                              return ClipOval(
                                child: Image.memory(
                                  snapshot.data as Uint8List,
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              // While the image is loading, show a loading indicator
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                ),
              ),
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
          ),
        )),
      ),
    );
  }
}
